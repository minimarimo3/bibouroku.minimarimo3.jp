#import "/book.typ": book-page, media

#show: book-page.with(title: "Typstの諸機能表示テスト")

= これは何？

Typstには色々な機能がありますが、それらがどこまでサポートされているのかを確認するためのページです。
自分が使うであろう基本的な部分だけ書いているものであり、網羅を目的としていないことに注意してください。

= 確認用

== aaa

#figure(caption: [キャプション],
  ```c 
  int main(void){
    printf("hogefuga: %d", neko);
  }
  ```
) <hogefugafigure>

ああ#[@hogefugafigure]いい

== 画像

#grid(columns: 3, inset: 10pt,
  [#figure(caption: [#link("https://www.irasutoya.com/2016/04/blog-post_119.html")[水の中で眠る会社員たちのイラスト]], 
    image("irasutoya_office_underwater.png", alt: "水の中で眠る会社員たちのイラスト")
    )<ira1>
  ],
  [#figure(caption: [#link("https://www.irasutoya.com/2019/03/blog-post_83.html")[青いカレーライスのイラスト]],
    image("irasutoya_food_curry_rice_blue.png", alt: "青いカレーライスのイラスト")
  )<ira2>],
  [#figure(caption: [#link("https://www.irasutoya.com/2016/03/blog-post_296.html")[スーパー日本人のイラスト]], 
   image("irasutoya_supuer_nihonjin.png", alt: "スーパー日本人のイラスト")
  )<ira3>]
)

@ira1 , @ira2 , @ira3

== bbb

`linebreak`実行前
#linebreak()
`linebreak`実行後

`pagebreak`実行前
#pagebreak()
`pagebreak`実行後

=== bbb2

$
P(union.big_(i=1)^infinity A_i) = sum_(i=1)^infinity P(A_i)
$

== ccc

たこ @noauthor_example_nodate 。#footnote("犬派？猫派？という質問に鳥派を入れて欲しいと思います")

#table(columns: 3,
  table.header("hoge", "huga", "piyo"),
  "hoge1", "fuga1", "piyo1",
  "hoge2", "fuga2", "piyo2",
  "hoge3", "fuga3", "piyo3",
)

#lorem(1000)

#bibliography("out.bib")
