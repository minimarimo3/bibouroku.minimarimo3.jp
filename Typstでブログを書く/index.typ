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

= アーキテクチャの概要

ファイル構成は#[@アーキテクチャの概要_ファイル構成]

#figure(caption: [],
  ```sh
  BIBOUROKU.MINIMARIMO3.JP
  │  index.typ
  │  posts.typ
  │  template.typ
  │  build.py
  │  404.typ
  │  template.pdf
  │
  ├─public
  │  │  index.html
  │  │  style.css
  │  │  404.html
  │  │  feed.xml
  │  │  sitemap.xml
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
  ├─Typstでブログを書く
  │      index.pdf
  │      index.typ
  │      Typstでブログを書く.yaml
  │
  ├─テスト
  │      index.pdf
  │      index.typ
  │      reference.bib
  │      テスト用画像.png
  │
  └─.github
    └─workflows
            deploy.yml
  ```
) <アーキテクチャの概要_ファイル構成>

普通のテンプレートと同じように動作します。

= 実装

== Typstのテンプレートを作成する

文書をHTMLエクスポートするだけなら`typst compile --features html --format html input.typ`すればよいのですが、この方法でコンパイルすると、styleやmetaであってもbody内に記述されてしまいます。
headに記述したい内容がある場合は`html.html`を使用してエクスポートするHTMLの構造を一から記述する必要があるみたいです。

また、0.14時点ではalign等のレイアウト系命令がエクスポート時に無視されるため、そのあたりはCSSを使用して実装する必要があります。

== サイトのアクセス解析を行う

アクセス解析に使えるのは色々ありますが
簡単に使えて同意を求めるプロンプトとか必要ないCloudflare Web Analyticsを採用します。

== 検索をサポートする

PageFindを使用して検索をサポートします。

== GitHub Actionsを作成しGitHub Pagesで公開する

`typst compile --features html --format html --root . (ディレクトリ)/index.typ public/(ディレクトリ)/index.html`

でおｋ！

= 詰まった点・落とし穴

== 数式のエクスポートが未実装

現時点では数式のエクスポートが未実装です。
しかし、数式をSVG画像に変換してHTMLに埋め込むことができます。

```typc
show math.equation.where(block: false): it => {
  html.elem("span", attrs: (role: "math"), html.frame(it))
}
show math.equation.where(block: true): it => {
  html.elem("figure", attrs: (role: "math"), html.frame(it))
}
```

== htmlを一から構築する場合footnoteが使用できない

`html.html`や`html.body`を使用して自分でHTMLの構造を指定する場合、footnoteを使用するとエラーが出ます。

```
error: footnotes are not currently supported in combination with a custom `<html>` or `<body>` element
   ┌─ \\?\G:\マイドライブ\bibouroku.minimarimo3.jp\テスト\index.typ:97:16
   │
97 │ これがノートを付けられる対象1#footnote[footnoteの中身1]
   │                               ^^^^^^^^^^^^^^^^^^^^^^^^^
   │
   = hint: you can still use footnotes with a custom footnote show rule
```

幸いcounterは使えるので自分で実装することで対処できます。

```typc
let note-counter = counter("my-footnote")
show footnote: it => {
  note-counter.step()
  let num = note-counter.get().first()
  html.span(class: "footnote-wrapper", {
    html.span(class: "footnote-marker", "[" + str(num) + "]")
    html.span(class: "footnote-content", it.body)
  })
}
```

#bibliography("Typstでブログを書く.yaml")
