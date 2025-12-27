#import "../template.typ": project, note, note, tip, important, warning, caution, raw_html
#import "../posts.typ": post-data
#let meta = post-data.at("テスト")
#show: project.with(..meta)


= TypstのHTMLエクスポート機能のテスト

これはただの文章です。

= 基本機能

*太字強調*

_斜体強調_

`生文字列`

```c
int main(void){
  printf("hello");
}
```

https://example.co.jp

- hoge
- fuga
+ piyo
+ moge

/ 用語: 説明内容

#quote(attribution: [Plato])[
  ... ἔοικα γοῦν τούτου γε σμικρῷ τινι αὐτῷ τούτῳ σοφώτερος εἶναι, ὅτι
  ἃ μὴ οἶδα οὐδὲ οἴομαι εἰδέναι.
]

#quote(attribution: [from the Henry Cary literal translation of 1897])[
  ... I seem, then, in just this little thing to be wiser than this man at
  any rate, that what I do not know I do not think I know either.
]

$(v dot nabla) v < "nya"$

'シングルクオート'

"ダブルクオート"

Typst 0.14ではカスタムHTMLエクスポート内だとfootnoteが使えません。
`footnote#footnote[footnoteの中身]`は下のようなエラーを出します。
```
error: footnotes are not currently supported in combination with a custom `<html>` or `<body>` element
   ┌─ \\?\C:\Users\minimarimo3\Temporary\typstSSG\main.typ:35:9
   │
35 │ footnote#footnote[footnoteの中身]
   │          ^^^^^^^^^^^^^^^^^^^^^^^^
   │
   = hint: you can still use footnotes with a custom footnote show rule
```
counterは使えるため自分で実装することになります。#[@footnote]を参照してください。

引用 @noauthor_vrm_2024 だよ @VRMコンソーシアム_米国KHRONOS_2024 。

#figure(caption: [画像（PDF）のfigure#linebreak()nekotako],
  image("./テスト用画像.png", alt: "てすととかかれた画像"),
) <テスト用画像>

#[@テスト用画像]は画像がテスト用であることを示しています。

#figure(caption: [表のfigure],
  table(
    columns: 3,
    table.header("hoge", "fuga", "piyo"),
    "hoge1", "fuga1", "piyo1",
    "hoge2", "fuga2", "piyo2",
    "hoge3", "fuga3", "piyo3",
  )
)

= カスタム

== アラート

#note[
  これは「補足」です。記事の端っこに書いておきたいちょっとした情報に使います。
]

#tip[
  これは「ヒント」です。役に立つテクニックなどを書くのに最適です。
]

#important[
  これは「重要」です。見逃してほしくない情報に使います。
]

#warning[
  これは「注意」です。ユーザーが気をつけるべき点です。
]

#caution[
  これは「警告」です。危険な操作や、取り返しのつかないことについて書きます。
]

== footnote<footnote>

これがノートを付けられる対象1#footnote[footnoteの中身1]

これがノートを付けられる対象2#footnote[https://example.co.jp #lorem(50) @noauthor_vrm_2024 ]

== サイトの埋め込み

#raw_html(`<iframe width="560" height="315" src="https://www.youtube.com/embed/eWw8HoNkVkU?si=t5T43P_gid2S7B5z" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>`)


#bibliography("reference.bib")

// comment

/* comment */
