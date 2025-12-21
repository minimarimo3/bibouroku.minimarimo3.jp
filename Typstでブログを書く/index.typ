#import "../template.typ": project, note, note, tip, important, warning, caution, env
#import "../posts.typ": post-data
#let meta = post-data.at("Typstでブログを書く")
#show: project.with(..meta)

#note[
  この記事は#link("https://qiita.com/advent-calendar/2025/typst")[Typst Advent Calender 2025]の23日目の記事です。
]

#env(
  ("Typst", "0.14", "TYPST_FEATURES=html"),
  ("Tinymist Typst", "0.14.4"),
)

= はじめに<はじめに>

Typst、とてもいいですよね。
Markdownのような手軽な書き心地でありながら、図表や脚注、参考文献まで美しく扱えるため、私も愛用しています。

そんなTypstですが、バージョン0.14でHTMLエクスポート機能が大幅に強化されました。
セマンティックな要素のほとんど#footnote[例えばカスタムHTML内での標準footnoteなど、一部未対応の機能もあります。]が適切なHTMLタグに変換されるようになったほか#[@Typst_Typst_Typst_0_14_Now_accessible_Ty]、`html.elem` を使うことで任意のHTMLタグを生成可能になりました。
つまり、TypstからHTMLのDOMツリーを直接操作できるようになったのです。

そこで今回はこの機能を活用して、Typstだけで記述・構築するブログシステムを作ってみました。
一般的なSSG（静的サイトジェネレータ）を使わず、記事の執筆からメタデータ管理までをTypst内部で完結させる仕組みです。

なお本システムのスクリプトはWTFPLライセンスで公開していますが、あくまで個人利用を目的とした実験的なものです。
その点はご了承ください。

= ファイル構成

ファイル構成は#[@ファイル構成]のようになっています。

トップレベルには5つのファイルがあります。
`index.typ`ではこのサイト(https://bibouroku.minimarimo3.jp)にアクセスしたとき最初に表示されるページを、
`style.css`ではサイト全体のテーマを、
`posts.typ`では記事のメタデータ（公開日、更新日、概要など）の管理を、
`template.typ`では記事のテンプレートを、
`build.py`では`posts.typ`のメタデータをもとにディレクトリを走査し、ビルドや添付ファイルの移動を担当しています。

`public`ディレクトリはビルド後の出力先です。
Webサイトとして公開するのはこのディレクトリになります。

その他ディレクトリは記事のディレクトリです。
このディレクトリに記事を書き、`posts.typ`にその記事のメタデータ（公開日、更新日、概要など）を記述することで
`index.typ`と`build.py`が記事の存在を認識しビルドされます。

記事を記述するファイル名が`index.typ`になっていますが、これはWebサイトの慣習によるものです。
`index.typ`をビルドすると通常`index.html`ができます。
この`index.html`という名前は特別なもので、URLにアクセスするファイル名が指定されていないときにデフォルトでアクセスするファイルです。

#figure(caption: [当ブログのファイル構成], ```sh
BIBOUROKU.MINIMARIMO3.JP
│  index.typ      # トップページ
│  style.css      # サイト全体のテーマを設定するファイル
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
```) <ファイル構成>

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

== 記事の情報をTypstで管理する

ブログのトップページやRSSフィードを作るには全記事のリストとそのデータ（更新日等）が必要です。
このために各記事ファイルのメタデータをまとめたファイル(`posts.typ`)で管理する仕組みを採用しました。
これによりTypstファイルからは下のような形で、
```typ
#import "../template.typ": project
#import "../posts.typ": post-data
#let meta = post-data.at("Typstでブログを書く")
#show: project.with(..meta)
```
ビルドスクリプト(Python)からは下のような形で同じ情報を取得することができます。
```py
result = subprocess.run(
    ["typst", "query", "posts.typ", "<post-list>"],
    capture_output=True,
    text=True,
    check=True,
    encoding="utf-8"
)
data = json.loads(result.stdout)
```

== 未実装機能への対処

=== 数式(Math)をSVG化して埋め込む

現状、数式のHTMLエクスポートは未実装です。
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

= まとめ

TypstでのHTML生成はまだ実験的な機能ですが、個人のブログや小規模なドキュメントサイトなら十分実用できるレベルにあると感じました。
何より、慣れ親しんだTypst記法で記事が書けて、それがそのままWebサイトになるのは非常に快適です。

#bibliography("Typstでブログを書く.yaml")
