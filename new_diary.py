#!/usr/bin/env python3
"""日記エントリを作成して開くヘルパースクリプト。

使い方:
  python3 new_diary.py          # 今日の日記を作成
  python3 new_diary.py 2026-03-25  # 指定日の日記を作成
"""

from __future__ import annotations

import datetime
import subprocess
import sys
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent
DIARY_DIR = ROOT_DIR / "diary"

TEMPLATE = """\
#import "../../template.typ": diary, d

#let meta = (
  slug: "diary-{date}",
  title: "{date}の日記",
  create: d({year}, {month}, {day}),
  description: "{year}年{month}月{day}日の日記",
  tags: ("日記",),
)

#metadata(meta) <post-meta>
#show: diary.with(..meta, mood: "", health: "")


= 今日の目標

-

= 振り返り



= 学んだこと



= 感謝



= 明日の予定

-
"""


def parse_date(arg: str) -> datetime.date:
    try:
        return datetime.date.fromisoformat(arg)
    except ValueError:
        print(f"❌ 日付の形式が正しくありません: {arg}（例: 2026-03-25）", file=sys.stderr)
        sys.exit(1)


def create_entry(date: datetime.date) -> Path:
    date_str = date.isoformat()
    entry_dir = DIARY_DIR / date_str
    entry_file = entry_dir / "index.typ"

    if entry_file.exists():
        print(f"📖 既に存在します: {entry_file.relative_to(ROOT_DIR)}")
        return entry_file

    entry_dir.mkdir(parents=True, exist_ok=True)
    content = TEMPLATE.format(
        date=date_str,
        year=date.year,
        month=date.month,
        day=date.day,
    )
    entry_file.write_text(content, encoding="utf-8")
    print(f"✅ 作成しました: {entry_file.relative_to(ROOT_DIR)}")
    return entry_file


def open_in_vscode(path: Path) -> None:
    try:
        subprocess.run(["code", "--reuse-window", str(path)], check=True)
    except FileNotFoundError:
        print(f"⚠️  VSCodeのcodeコマンドが見つかりません。手動で開いてください:\n   {path}")
    except subprocess.CalledProcessError:
        print(f"⚠️  VSCodeで開けませんでした。手動で開いてください:\n   {path}")


def main() -> None:
    if len(sys.argv) > 2:
        print("使い方: python3 new_diary.py [YYYY-MM-DD]", file=sys.stderr)
        sys.exit(1)

    date = parse_date(sys.argv[1]) if len(sys.argv) == 2 else datetime.date.today()
    entry_file = create_entry(date)
    open_in_vscode(entry_file)


if __name__ == "__main__":
    main()
