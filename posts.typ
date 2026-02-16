// --- 入力支援用ヘルパー関数 ---

// 日付を短く書くための関数: d(2025, 12, 14) でOKにする
#let d(y, m, d) = datetime(year: y, month: m, day: d)

// 記事データを登録する関数
#let post(
  dir,    // 第1引数: ディレクトリ名 (URLになります)
  create,   // 第2引数: 作成日 (d関数を使うと楽)
  title: auto,  // タイトル (省略したらディレクトリ名と同じになります)
  update: none, // 更新日
  desc: "",     // 説明文
  tags: (),     // タグ
) = {
  (
    dir,
    (
      title: if title == auto { dir } else { title },
      create: create,
      update: update,
      description: desc,
      tags: tags,
    ),
  )
}

// --- 記事リスト ---
#let post-data = (
  post(
    "スマホのブラウザでYouTube Shortをブロックする",
    d(2026, 02, 16),
    desc: "Vivaldiのトラッカーブロック機能でYouTubeショートを非表示にした際の備忘録",
    tags: ("YouTube ショート", "Vivaldi"),
  ),
  post(
    "Typstでブログを書く",
    d(2025, 12, 14),
    update: d(2025, 12, 21),
    desc: "Typst 0.14でHTML出力が強化されたのを機に執筆からデータ管理までTypstだけで完結するブログシステムを自作してみました。記事のメタデータをTypstファイルで管理する仕組みや、数式・脚注の表示崩れへの対処法など、Typst中心のサイト構築方法をまとめました。",
    tags: ("Typst", "HTML"),
  ),
  post(
    "テスト",
    d(2025, 12, 12),
    desc: "サイトの表示テスト",
    tags: ("テスト",),
  ),
).to-dict()

#metadata(post-data) <post-list>
