#import "/book.typ": book-page, media, cross-link, heading-reference, page-width

#show: book-page.with(title: "shiroa独自の機能")

= shiroaによって使えるようになる機能

== 他ファイルへのリンク

```typ
// pathは絶対座標である必要がある
#let path = "/Typstの諸機能表示テスト/Typstの諸機能表示テスト.typ"

#cross-link(path)[これは"Typstの諸機能表示テスト"へ移動するリンク]

/*
heading-referenceを使うためには`book.typ`の

// re-export page template
#import "/templates/page.typ": project

のpage.typから`heading-reference`をimportする必要があるっぽい。↓みたいに

#import "/templates/page.typ": project, heading-reference
*/
#let jump_ref = heading-reference[== これは何？]
#cross-link(path, reference: jump_ref)[これは"Typstの諸機能表示テスト"の"これは何？"セクションに移動するリンク]
```

#let path = "/Typstの諸機能表示テスト/Typstの諸機能表示テスト.typ"

#cross-link(path)[これは"Typstの諸機能表示テスト"へ移動するリンク]

#let jump_ref = heading-reference[== これは何？]
#cross-link(path, reference: jump_ref)[これは"Typstの諸機能表示テスト"の"これは何？"セクションに移動するリンク]

== media機能

公式ドキュメントや下の使用例からも分かるように、コードを貼るだけでそのまま使えるような状態にはなっていないのであまり使わない方がいいかもしれません。
あとコード読む限り埋め込み用のiframeに関しては無くすかどうか悩んでいるっぽい。

```typ #import "/book.typ": book-page, media```でmediaを入れる必要がある。
あと埋め込みを許可しているドメインはデフォルト状態だと`^(player.bilibili.com)$`なのでビルド時に`--allowed-url-source ".*"`と設定して全部許した方がいいと思う。
別に埋め込む予定のドメイン列挙してもいいよ。
注意する点として、パラメーターはURLって言ってるけど実際にマッチさせるのはホスト部なので`"^(https://.*)$"`とか書くと何も出力されないってのがある。

バグとして、`media.*`が複数あるときに再生等の操作が一切できなくなるというものがあるっぽい。
Issueにも無かったのでよく分からんがpagebreakを入れたら直った。
多分同一ページに2つ以上`media.*`があるとダメ。

=== 音声

```typ
#media.audio(
  attributes: (
    // ./test.mp3みたいに書いても読み込んではくれないらしい。ローカルのファイルを出したいなら多分公開後にリンクを貼ってあげる必要がある
    src: "https://onlinetestcase.com/wp-content/uploads/2023/06/1-MB-MP3.mp3",
    controls:"true",
  )
)
```

#media.audio(
  attributes: (
    src: "https://onlinetestcase.com/wp-content/uploads/2023/06/1-MB-MP3.mp3",
    controls: "true",
  )
)
#pagebreak()

スペースを開けたく無いならこう↓

```typ 
#media.audio(
  outer-width:  80pt, // 80は適当
  outer-height: 80pt, // 80は適当
  attributes: (
    src: "https://onlinetestcase.com/wp-content/uploads/2023/06/1-MB-MP3.mp3",
    controls:"true",
  )
)
```

#media.audio(
  outer-width:  80pt,
  outer-height: 80pt,
  attributes: (
    src: "https://onlinetestcase.com/wp-content/uploads/2023/06/1-MB-MP3.mp3",
    controls:"true",
  )
)
#pagebreak()

=== ビデオ読み込み

```typ
#media.video(
  attributes: (
    src: "https://onlinetestcase.com/wp-content/uploads/2023/06/1MB.mp4",
    controls: "true"
  )
)
```

#media.video(
  attributes: (
    src: "https://onlinetestcase.com/wp-content/uploads/2023/06/1MB.mp4",
    controls: "true"
  )
)
#pagebreak()

=== サイト埋め込み

```typ
#media.iframe(
  outer-width: 640pt,
  outer-height: 360pt,
  attributes: (
    src: "https://player.bilibili.com/player.html?aid=80433022&bvid=BV1GJ411x7h7&cid=137649199&page=1&danmaku=0&autoplay=0",
    scrolling: "no",
    border: "0",
    width: "100%",
    height: "100%",
    frameborder: "no",
    framespacing: "0",
    allowfullscreen: "true",
  ),
)
```


#media.iframe(
  outer-width: 640pt,
  outer-height: 360pt,
  attributes: (
    src: "https://player.bilibili.com/player.html?aid=80433022&bvid=BV1GJ411x7h7&cid=137649199&page=1&danmaku=0&autoplay=0",
    scrolling: "no",
    border: "0",
    width: "100%",
    height: "100%",
    frameborder: "no",
    framespacing: "0",
    allowfullscreen: "true",
  ),
)
#pagebreak()

```typ
#media.iframe(
  outer-width: 560pt,
  outer-height: 315pt,
  attributes: (
    src: "https://www.youtube.com/embed/YzuWMyd7Pjk?si=IVzCj73mCIs9AD1E",
    frameborder: "0",
    allowfullscreen: "true",
  ),
)
```

#media.iframe(
  outer-width: 784pt,
  outer-height: 441pt,
  attributes: (
    src: "https://www.youtube.com/embed/YzuWMyd7Pjk?si=IVzCj73mCIs9AD1E",
    frameborder: "0",
    allowfullscreen: "true",
    width: "100%",
    height: "100%",
  ),
)
#pagebreak()

=== その他

div: divを作れるらしい。確認してない。

xhtml, xcommand: Typst側のshiroaとの通信用。気にする必要はない。
#footnote([
  簡単な説明: 俺らが`media.iframe`や`media.video`は一旦SVG画像のコメントにJSONとして書き込まれる。
  それを（Typstの拡張機能として実装されている方の）shiroaがTypst側で取り出し、JSONに応じて適切なHTMLを生成する。
  そのJSONへの変更とSVGとしての埋め込みをやるのがxhtmlとxcommand。
  なおJSON内のタグはshiroa拡張機能が検証しているので好き勝手埋め込める訳ではなさそう。
])
