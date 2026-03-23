from __future__ import annotations

import datetime as dt
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path
from xml.sax.saxutils import escape

ROOT_DIR = Path(__file__).resolve().parent
OUTPUT_DIR = ROOT_DIR / "public"
GENERATED_POSTS_FILE = ROOT_DIR / "typst" / "generated" / "posts.typ"
BASE_URL = "https://bibouroku.minimarimo3.jp"
STYLE_CSS = ROOT_DIR / "style.css"
SCRIPT_JS = ROOT_DIR / "script.js"
ROBOTS_TXT = ROOT_DIR / "robots.txt"
POST_METADATA_LABEL = "<post-meta>"
EXCLUDED_DIRS = {".git", ".github", "public", "template", "typst", "__pycache__"}
STATIC_EXTENSIONS = {
    ".png",
    ".jpg",
    ".jpeg",
    ".gif",
    ".svg",
    ".webp",
    ".pdf",
    ".js",
    ".yaml",
    ".yml",
    ".bib",
    ".txt",
}


def run_typst(*args: str, capture_output: bool = False) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["typst", *args],
        cwd=ROOT_DIR,
        check=True,
        text=True,
        encoding="utf-8",
        capture_output=capture_output,
    )


def parse_typst_date(raw: str | None) -> dt.datetime | None:
    if not raw:
        return None

    match = re.search(r"year:\s*(\d+),\s*month:\s*(\d+),\s*day:\s*(\d+)", raw)
    if not match:
        return None

    return dt.datetime(
        int(match.group(1)),
        int(match.group(2)),
        int(match.group(3)),
        tzinfo=dt.timezone.utc,
    )


def typst_string(value: str) -> str:
    escaped = value.replace("\\", "\\\\").replace('"', '\\"')
    return f'"{escaped}"'


def format_typst_date(value: dt.datetime | None) -> str:
    if value is None:
        return "none"
    return f"datetime(year: {value.year}, month: {value.month}, day: {value.day})"


def discover_post_files() -> list[Path]:
    post_files: list[Path] = []
    for path in ROOT_DIR.rglob("index.typ"):
        if path == ROOT_DIR / "index.typ":
            continue
        if any(part in EXCLUDED_DIRS for part in path.relative_to(ROOT_DIR).parts):
            continue
        post_files.append(path)
    return sorted(post_files)


def load_post_metadata(path: Path) -> dict | None:
    result = run_typst(
        "query",
        "--root",
        ".",
        "--features",
        "html",
        "--field",
        "value",
        str(path.relative_to(ROOT_DIR)),
        POST_METADATA_LABEL,
        capture_output=True,
    )
    data = json.loads(result.stdout)
    if not data:
        return None
    return data[0]


def collect_posts() -> list[dict]:
    posts: list[dict] = []
    seen_slugs: set[str] = set()

    for source_file in discover_post_files():
        meta = load_post_metadata(source_file)
        if meta is None:
            continue

        slug = meta.get("slug")
        title = meta.get("title")
        create = parse_typst_date(meta.get("create"))
        update = parse_typst_date(meta.get("update"))
        description = meta.get("description")
        tags = tuple(meta.get("tags", []))
        draft = bool(meta.get("draft", False))

        if not slug:
            raise ValueError(f"{source_file.relative_to(ROOT_DIR)}: slug is required")
        if slug in seen_slugs:
            raise ValueError(f"duplicate slug: {slug}")
        seen_slugs.add(slug)

        if not title:
            raise ValueError(f"{source_file.relative_to(ROOT_DIR)}: title is required")
        if create is None:
            raise ValueError(f"{source_file.relative_to(ROOT_DIR)}: create is required")
        if not description:
            raise ValueError(f"{source_file.relative_to(ROOT_DIR)}: description is required")

        posts.append(
            {
                "slug": slug,
                "title": title,
                "create": create,
                "update": update,
                "description": description,
                "tags": tags,
                "draft": draft,
                "source_file": source_file,
                "source_dir": source_file.parent,
            }
        )

    posts.sort(key=lambda post: post["create"], reverse=True)
    return posts


def write_generated_posts(posts: list[dict]) -> None:
    published_posts = [post for post in posts if not post["draft"]]

    lines = ["#let post-data = ("]
    for post in published_posts:
        tag_value = (
            "(" + ", ".join(typst_string(tag) for tag in post["tags"]) + ("," if len(post["tags"]) == 1 else "") + ")"
            if post["tags"]
            else "()"
        )
        lines.extend(
            [
                f"  {typst_string(post['slug'])}: (",
                f"    title: {typst_string(post['title'])},",
                f"    create: {format_typst_date(post['create'])},",
                f"    update: {format_typst_date(post['update'])},",
                f"    description: {typst_string(post['description'])},",
                f"    tags: {tag_value},",
                "  ),",
            ]
        )
    lines.append(")")
    GENERATED_POSTS_FILE.write_text("\n".join(lines) + "\n", encoding="utf-8")


def copy_post_assets(post: dict, output_dir: Path) -> None:
    for asset in post["source_dir"].rglob("*"):
        if not asset.is_file():
            continue
        if asset == post["source_file"]:
            continue
        if asset.suffix.lower() not in STATIC_EXTENSIONS:
            continue

        relative_path = asset.relative_to(post["source_dir"])
        destination = output_dir / relative_path
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(asset, destination)


def build_post(post: dict) -> None:
    output_dir = OUTPUT_DIR / post["slug"]
    output_dir.mkdir(parents=True, exist_ok=True)
    output_file = output_dir / "index.html"

    print(f"🔨 Compiling: {post['title']}")
    run_typst(
        "compile",
        "--features",
        "html",
        "--format",
        "html",
        "--root",
        ".",
        str(post["source_file"].relative_to(ROOT_DIR)),
        str(output_file.relative_to(ROOT_DIR)),
    )
    copy_post_assets(post, output_dir)


def copy_root_assets() -> None:
    if STYLE_CSS.exists():
        shutil.copy2(STYLE_CSS, OUTPUT_DIR / STYLE_CSS.name)
    if SCRIPT_JS.exists():
        shutil.copy2(SCRIPT_JS, OUTPUT_DIR / SCRIPT_JS.name)
    if ROBOTS_TXT.exists():
        shutil.copy2(ROBOTS_TXT, OUTPUT_DIR / ROBOTS_TXT.name)


def build_static_pages() -> None:
    run_typst(
        "compile",
        "--features",
        "html",
        "--format",
        "html",
        "--root",
        ".",
        "index.typ",
        str((OUTPUT_DIR / "index.html").relative_to(ROOT_DIR)),
    )

    if (ROOT_DIR / "404.typ").exists():
        run_typst(
            "compile",
            "--features",
            "html",
            "--format",
            "html",
            "--root",
            ".",
            "404.typ",
            str((OUTPUT_DIR / "404.html").relative_to(ROOT_DIR)),
        )

    copy_root_assets()


def generate_rss(posts: list[dict]) -> None:
    published_posts = [post for post in posts if not post["draft"]]
    rss_path = OUTPUT_DIR / "feed.xml"
    now = dt.datetime.now(dt.timezone.utc).strftime("%a, %d %b %Y %H:%M:%S GMT")

    xml = f"""<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
<channel>
  <title>Bibouroku</title>
  <link>{BASE_URL}</link>
  <description>Typstで作られた備忘録ブログ</description>
  <lastBuildDate>{now}</lastBuildDate>
"""
    for post in published_posts:
        link = f"{BASE_URL}/{post['slug']}/"
        pub_date = post["create"].strftime("%a, %d %b %Y 00:00:00 GMT")
        xml += f"""  <item>
    <title>{escape(post['title'])}</title>
    <link>{link}</link>
    <description>{escape(post['description'])}</description>
    <pubDate>{pub_date}</pubDate>
  </item>
"""

    xml += "</channel>\n</rss>"
    rss_path.write_text(xml, encoding="utf-8")


def generate_sitemap(posts: list[dict]) -> None:
    published_posts = [post for post in posts if not post["draft"]]
    sitemap_path = OUTPUT_DIR / "sitemap.xml"

    xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>{BASE_URL}/</loc>
    <priority>1.0</priority>
  </url>
"""
    for post in published_posts:
        link = f"{BASE_URL}/{post['slug']}/"
        last_mod = (post["update"] or post["create"]).strftime("%Y-%m-%d")
        xml += f"""  <url>
    <loc>{link}</loc>
    <lastmod>{last_mod}</lastmod>
    <priority>0.8</priority>
  </url>
"""

    xml += "</urlset>"
    sitemap_path.write_text(xml, encoding="utf-8")


def build() -> None:
    print("🚀 ビルドを開始します...")

    if OUTPUT_DIR.exists():
        shutil.rmtree(OUTPUT_DIR)
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    posts = collect_posts()
    published_count = sum(1 for post in posts if not post["draft"])
    print(f"📄 {len(posts)} 件の記事メタデータを取得しました（公開 {published_count} 件）。")

    write_generated_posts(posts)

    for post in posts:
        if post["draft"]:
            print(f"📝 Draft skip: {post['title']}")
            continue
        build_post(post)

    print("\n🏠 Building static pages...")
    build_static_pages()

    print("\n📡 Generating RSS & Sitemap...")
    generate_rss(posts)
    generate_sitemap(posts)

    print("\n✅ ビルド完了！")


if __name__ == "__main__":
    try:
        build()
    except Exception as exc:
        print(f"\n❌ ビルド失敗: {exc}", file=sys.stderr)
        sys.exit(1)
