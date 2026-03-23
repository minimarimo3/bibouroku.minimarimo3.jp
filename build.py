import subprocess
import json
import re
import os
import shutil
import datetime
import sys
from xml.sax.saxutils import escape

# --- 設定 ---
ROOT_DIR = "."
POSTS_FILE = "posts.typ"
METADATA_LABEL = "<post-list>"
BASE_URL = "https://bibouroku.minimarimo3.jp"  # あなたのドメイン
STYLE_CSS = "style.css"  # 共通CSSのファイル名
SCRIPT_JS = "script.js"  # 共通JSのファイル名
ROBOTS_TXT = "robots.txt"  # robots.txtのファイル名

# コピーする静的ファイルの拡張子（必要に応じて追加）
STATIC_EXTENSIONS = {".png", ".jpg", ".jpeg", ".gif", ".svg", ".webp", ".pdf", ".js"}

def build():
    print("🚀 ビルドを開始します...")
    has_error = False  # エラー状態を追跡するフラグ
    
    # publicフォルダのリセット（必要ならコメントアウトを外す）
    if os.path.exists("public"):
        shutil.rmtree("public")
    os.makedirs("public", exist_ok=True)

    # 1. 記事リストの取得
    try:
        result = subprocess.run(
            ["typst", "query", "--field", "value", POSTS_FILE, METADATA_LABEL],
            capture_output=True,
            text=True,
            check=True,
            encoding="utf-8"
        )
        posts_dict = json.loads(result.stdout)[0]
        print(f"📄 {len(posts_dict)} 件の記事が見つかりました。\n")
    except Exception as e:
        print(f"❌ 致命的なエラー: 記事リストの取得に失敗しました。\n{e}")
        sys.exit(1)  # 記事リストが取得できない場合は以降の処理が不可能なため即時終了

    # 記事リストを日付順にソート（新しい順）
    sorted_posts = []
    for dir_path, meta in posts_dict.items():
        meta["dir_path"] = dir_path
        # 日付のパース処理
        create_date = meta.get("create")
        match = re.search(r"year:\s*(\d+),\s*month:\s*(\d+),\s*day:\s*(\d+)", create_date)
        if match:
            dt = datetime.datetime(
                int(match.group(1)),
                int(match.group(2)),
                int(match.group(3))
            )
        meta["dt"] = dt
        sorted_posts.append(meta)

    sorted_posts.sort(key=lambda x: x["dt"], reverse=True)


    # 2. 各記事のビルド & 静的ファイルコピー
    for post in sorted_posts:
        dir_path = post["dir_path"]
        title = post.get("title", "無題")
        
        # パス設定
        input_dir = os.path.join(ROOT_DIR, dir_path)
        input_file = os.path.join(input_dir, "index.typ")
        output_dir = os.path.join("public", dir_path)
        output_file = os.path.join(output_dir, "index.html")
        
        if not os.path.exists(input_file):
            print(f"⚠️ スキップ: ファイルが見つかりません ({input_file})")
            continue

        os.makedirs(output_dir, exist_ok=True)
        print(f"🔨 Compiling: {title}")

        # (A) Typstコンパイル
        try:
            subprocess.run([
                "typst", "compile", "--features", "html", "--format", "html",
                "--root", ROOT_DIR, input_file, output_file
            ], check=True)
        except subprocess.CalledProcessError:
            print(f"❌ コンパイル失敗: {title}")
            has_error = True  # エラーを記録して次の記事へ
            continue

        # (B) 静的ファイル（画像など）のコピー
        for filename in os.listdir(input_dir):
            base, ext = os.path.splitext(filename)
            if ext.lower() in STATIC_EXTENSIONS:
                src = os.path.join(input_dir, filename)
                dst = os.path.join(output_dir, filename)
                shutil.copy2(src, dst)
                print(f"  Example: {filename} をコピーしました")

    # 3. 共通ファイルのビルド・コピー
    print("\n🏠 Building static pages...")
    
    # トップページ
    try:
        subprocess.run(["typst", "compile", "--features", "html", "--format", "html", "--root", ROOT_DIR, "index.typ", "public/index.html"], check=True)
    except subprocess.CalledProcessError:
        print("❌ トップページのコンパイル失敗")
        has_error = True

    # 404ページ
    if os.path.exists("404.typ"):
        try:
            subprocess.run(["typst", "compile", "--features", "html", "--format", "html", "--root", ROOT_DIR, "404.typ", "public/404.html"], check=True)
            print("✅ 404ページ生成完了")
        except subprocess.CalledProcessError:
            print("❌ 404ページのコンパイル失敗")
            has_error = True

    # CSSコピー
    if os.path.exists(STYLE_CSS):
        shutil.copy2(STYLE_CSS, "public/style.css")
        print("✅ CSSコピー完了")
    else:
        print("⚠️ style.css がルートに見つかりません（public/style.cssとして既に存在するならOK）")

    # JSコピー
    if os.path.exists(SCRIPT_JS):
        shutil.copy2(SCRIPT_JS, "public/script.js")
        print("✅ JSコピー完了")
    else:
        print("⚠️ script.js がルートに見つかりません（public/script.jsとして既に存在するならOK）")

    # robots.txtコピー
    if os.path.exists(ROBOTS_TXT):
        shutil.copy2(ROBOTS_TXT, "public/robots.txt")
        print("✅ robots.txtコピー完了")
    else:
        print("⚠️ robots.txt がルートに見つかりません（public/robots.txtとして既に存在するならOK）")


    # 4. RSSフィード & サイトマップ生成
    print("\n📡 Generating RSS & Sitemap...")
    generate_rss(sorted_posts)
    generate_sitemap(sorted_posts)
    
    # 最終的なエラーステータスの判定と終了コードの返却
    if has_error:
        print("\n❌ ビルド中に一つ以上のエラーが発生しました。ログを確認してください。")
        sys.exit(1)
    else:
        print("\n✅ ビルド完了！")


def generate_rss(posts):
    rss_path = os.path.join("public", "feed.xml")
    now = datetime.datetime.now(datetime.timezone.utc).strftime("%a, %d %b %Y %H:%M:%S GMT")
    
    xml = f"""<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
<channel>
  <title>Bibouroku</title>
  <link>{BASE_URL}</link>
  <description>Typstで作られた備忘録ブログ</description>
  <lastBuildDate>{now}</lastBuildDate>
"""
    for post in posts:
        title = escape(post.get("title", "No Title"))
        link = f"{BASE_URL}/{post['dir_path']}/" # トレーリングスラッシュあり
        desc = escape(post.get("description", ""))
        # 日付フォーマット (RFC 822)
        pub_date = post["dt"].strftime("%a, %d %b %Y 00:00:00 GMT")
        
        xml += f"""  <item>
    <title>{title}</title>
    <link>{link}</link>
    <description>{desc}</description>
    <pubDate>{pub_date}</pubDate>
  </item>
"""
    xml += "</channel>\n</rss>"
    
    with open(rss_path, "w", encoding="utf-8") as f:
        f.write(xml)

def generate_sitemap(posts):
    sitemap_path = os.path.join("public", "sitemap.xml")
    
    xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>{BASE_URL}/</loc>
    <priority>1.0</priority>
  </url>
"""
    for post in posts:
        link = f"{BASE_URL}/{post['dir_path']}/"
        last_mod = post["dt"].strftime("%Y-%m-%d")
        
        xml += f"""  <url>
    <loc>{link}</loc>
    <lastmod>{last_mod}</lastmod>
    <priority>0.8</priority>
  </url>
"""
    xml += "</urlset>"
    
    with open(sitemap_path, "w", encoding="utf-8") as f:
        f.write(xml)

if __name__ == "__main__":
    build()
