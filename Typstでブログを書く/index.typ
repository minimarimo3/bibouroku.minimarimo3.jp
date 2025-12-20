#import "../template.typ": project, note, note, tip, important, warning, caution, env
#import "../posts.typ": post-data
#let meta = post-data.at("Typstでブログを書く")
#show: project.with(..meta)

#note[
  この記事は#link("https://qiita.com/advent-calendar/2025/typst")[Typst Advent Calender 2025]のTODO日目の記事です。
]

#env(
  ("Typst", "0.14", "TYPST_FEATURES=html",),
  ("Tinymist Typst", "0.14.4",)
)

= はじめに<はじめに>

Typst、とてもいいですよね。
Markdownのような書き心地でfigureやfootnoteや参考文献への参照等が書けるためとても気に入っています。

そのTypstですがバージョン0.14でHTMLエクスポート機能が大幅に強化されました。
なんとほとんど#footnote[例えばカスタムHTML内でのfootnoteなどはまだ使えません]の#link("https://typst.app/docs/reference/model/")[セマンティック要素(Modelカテゴリの要素)]がHTMLとして適切に変換できるようになり#[@Typst_Typst_Typst_0_14_Now_accessible_Ty]、また、`html.elem`を使用して任意のHTMLタグをTypstから生成できるようになりました。
これによりTypstはHTMLのDOMツリーを直接操作できるようになりました。

そんなわけで実際にTypstだけで記述可能なブログシステムを作ってみました。
SSG(Static Site Generator)のようなものを構築したのですが、記事の記述等々をTypst内部だけで完結させた点が面白かったのでその裏側を紹介します。

なお、スクリプトはWTFPLで公開しているものの、個人用に作ったものであるため他人が使うことを想定していません。
現時点でもここまでできるんだよということを紹介するためのものとして受け取ってもらいたいです。

= ファイル構成

ファイル構成は#[@ファイル構成]のようになっています。

#figure(caption: [当ブログのファイル構成],
  ```sh
  BIBOUROKU.MINIMARIMO3.JP
  │  index.typ      # トップページ
  │  style.css      # サイトのスタイルシート
  │  posts.typ      # 公開対象の記事のメタデータを記述するファイル
  │  template.typ   # 記事のテンプレート
  │  build.py       # posts.typのデータをもとにディレクトリを走査し、ビルドと添付ファイルの移動を行うスクリプト
  │
  ├─public          # ビルド後の出力先
  │  │  index.html
  │  │  style.css
  │  │  feed.xml    # build.pyによって生成されます
  │  │  sitemap.xml # build.pyによって生成されます
  │  │
  │  ├─Typstでブログを書く
  │  │      index.html
  │  │      index.pdf
  │  │
  │  └─テスト
  │          index.html
  │          index.pdf
  │          テスト用画像.png
  │
  ├─Typstでブログを書く # 記事1
  │      index.pdf
  │      index.typ
  │      Typstでブログを書く.yaml
  │
  ├─テスト             # 記事2
  │      index.pdf
  │      index.typ
  │      reference.bib
  │      テスト用画像.png
  │
  └─.github
    └─workflows
            deploy.yml
  ```
) <ファイル構成>

/*
= 使用方法

記事はディレクトリごとに記述していく形になります。
`記事を公開するディレクトリ名/index.typ`は記事のメインファイルで、ここに記事を記述します。

記事一覧やRSSフィードを作るには全記事のリストが必要です。
Pythonでディレクトリをスキャンすることもできるのですが、幸いTypstには#link("https://typst.app/docs/reference/introspection/metadata/")[metadata]という関数があります。
この関数は文書内にメタデータを埋め込むことができる関数で、Typstファイルのみならず`typst query`コマンドを使うことでtypst cliからもJSON形式でその情報を取得できるすぐれものです。

通常のテンプレートであれば`#import "../template.typ": project`で`project.with(title: "hogehoge")`と書いていくことになると思うのですが、
*/

= 実装

== `html.html`で出力されるHTMLの構造をカスタマイズ

`html.html`や`html.head`を使用せずにHTMLエクスポートすると、文書の内容はすべてbodyタグ内に記述されることになります。
これは`html.style`や`html.meta`であってもbodyタグ内に記述されるということです。
headに記述したい内容がある場合は`html.html`を使用してエクスポートするHTMLの構造を一から記述する必要があるみたいです。

今回のブログでは、`template.typ`内に以下のような構造を定義しました。

```typc
html.html(lang: "ja", {
  html.head({
    html.meta(charset: "utf-8")
    html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
    html.title(title)
    
    // OGP設定やGoogle Fontsの読み込み
    if description != "" {
      html.meta(name: "description", content: description)
    }
    html.elem("meta", attrs: (property: "og:title", content: title))
    html.link(rel: "stylesheet", href: "/style.css")
    html.link(rel: "preconnect", href: "https://fonts.googleapis.com")
    html.link(rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous")
    
    html.script(src: "/script.js")
    html.link(rel: "stylesheet", href: "/style.css")
  })
  
  html.body({
    html.div(class: "site-container", {
      // ヘッダー、記事本文、サイドバーなどを自由に配置
      html.main(class: "main-content", body)
      html.aside(class: "sidebar", { ... })
    })
  })
})
```

== 関連記事のランダム生成

外部スクリプトで計算した結果を渡すのではなく、Typst内部で乱数を生成して記事を選んでいます。
ただし、ビルドのたびに関連記事が変わるのは困るので記事タイトルのハッシュ地をシードにして乱数を固定しています。

```typc
// template.typより抜粋
#import "@preview/suiji:0.5.0": *

// 記事タイトルを数値化してシードにする
let seed = int(title.clusters().map(str.to-unicode).map(str).join().slice(0, 14))
let rng = gen-rng(seed)

// 記事リストをシャッフル
let (_, indices) = shuffle-f(rng, range(other-posts.len()))

// 上位3件を取得
let picks = indices.slice(0, 3).map(i => other-posts.at(i))
```

== 未実装機能への対処

=== 数式(Math)をSVG化して埋め込む

現状、数式のHTMLエクスポートは未実装（または不完全）です。
そこで、数式を html.frame で一度フレーム（画像的な扱い）にし、SVGとしてHTML内に展開することで表示させました。
```typc
show math.equation.where(block: false): it => {
  html.elem("span", attrs: (role: "math"), html.frame(it))
}
show math.equation.where(block: true): it => {
  html.elem("figure", attrs: (role: "math"), html.frame(it))
}
```

=== カスタムHTML構造での注釈(Footnote)

`html.html`を使ってカスタム構造を作ると、標準の #footnote がエラーになります。

```
error: footnotes are not currently supported in combination with a custom `<html>` or `<body>` element
   ┌─ \\?\G:\マイドライブ\bibouroku.minimarimo3.jp\テスト\index.typ:97:16
   │
97 │ これがノートを付けられる対象1#footnote[footnoteの中身1]
   │                               ^^^^^^^^^^^^^^^^^^^^^^^^^
   │
   = hint: you can still use footnotes with a custom footnote show rule
```

幸いcounterは使えるので自分で実装することで対処することができます。

```typc
let note-counter = counter("my-footnote")
show footnote: it => {
  note-counter.step()
  let num = note-counter.get().first()
  // CSSでツールチップ表示するためのHTML構造を出力
  html.span(class: "footnote-wrapper", {
    html.span(class: "footnote-marker", "※" + str(num))
    html.span(class: "footnote-content", it.body)
  })
}
```

== GitHub Actionsを作成しGitHub Pagesで公開する

`typst compile --features html --format html --root . (ディレクトリ)/index.typ public/(ディレクトリ)/index.html`

でおｋ！

#bibliography("Typstでブログを書く.yaml")
