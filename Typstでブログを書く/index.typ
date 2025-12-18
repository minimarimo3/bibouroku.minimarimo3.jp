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
そのTypstですがバージョン0.13でHTMLエクスポート機能が実験的に実装され、バージョン0.14では（依然として発展途上の機能ではあるものの）その機能が大幅に強化され、変換対象の関数も増えた上に、`html.elem`を使うことで直接HTMLタグを記述できるようになりました。

そこで今ならTypstでブログ作れるんじゃねぇかと考えたのです。
作ったのがこのブログです。

TypstでHTMLを生成しCSSで色付けるだけなので技術的に難しいことはないのですがいくつか落とし穴があるのと、HTMLエクスポートを実際に使用してみた内容の日本語の記事がみあたらなかったので記事を残すことにしました。

一応色々WTFPLで公開しているものの、個人用に作ったものであるため他人が使うことを想定していません。
現時点でもここまでできるんだよということを紹介するためのものとして受け取ってもらいたいです。

TypstのHTMLエクスポート機能はデフォルトだと有効化されていないためTinymistで`html.hogehoge`を使うと`html`なんてねぇよというエラーが出てしまいます。
`TYPST_FEATURES`変数にhtmlを設定してVSCodeを再起動することによって拡張機能にhtml機能を認識させることができます。

= 実装

== Typstのテンプレートを作成する

文書をHTMLエクスポートするだけなら`typst compile --features html --format html input.typ`すればよいのですが、この方法でコンパイルすると、styleやmetaであってもbody内に記述されてしまいます。
headに記述したい内容がある場合は`html.html`を使用してエクスポートするHTMLの構造を一から記述する必要があるみたいです。

また、0.14時点ではalign等のレイアウト系命令がエクスポート時に無視されるため、そのあたりはCSSを使用して実装する必要があります。

== Zoteroのエクスポート形式にHayagrivaを追加、キーをWebサイトメインに修正

まずTypstの`bibliography`はBibLaTeXとHayagrivaの二つの形式をロード可能です。
HayagrivaというのはTypstが開発している文献管理用の形式でYAMLを使用しています。

単にブログを書くだけなら文献リストはYAMLの方が取り回しがよいでしょう。
しかし、ZoteroのエクスポートはHayagriva（Typstが開発しているbibliographyの管理用形式）に対応していません。
というわけで作成したのがこちらです。

論文を書くことはないのでWeb用にカスタマイズしてあります。

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

`html.html`でファイルを生成する場合、footnoteを使用するとエラーが出ます。
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

#bibliography("test.yaml")
