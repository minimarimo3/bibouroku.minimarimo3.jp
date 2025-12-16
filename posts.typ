/*
  "": (
    title: "",
    create: datetime(year: 2025, month: 12, day: ),
    update: datetime(year: 2025, month: 12, day: ),
    description: "",
    tags: ("", ""),
  ),
*/

#let post-data = (
  "Typstでブログを書く": (
    title: "Typstでブログを書く",
    create: datetime(year: 2025, month: 12, day: 14),
    update: datetime(year: 2025, month: 12, day: 15),
    description: "Typst v0.14の新機能を使って、Typstだけでブログシステムを構築する試み。",
    tags: ("Typst", "HTML"),
  ),
  "テスト": (
    title: "テスト",
    create: datetime(year: 2025, month: 12, day: 12),
    description: "サイトの表示テスト",
    tags: ("テスト",),
  ),
)

#metadata(post-data) <post-list>
