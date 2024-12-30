#import "/book.typ": book-page, media, cross-link, heading-reference

#show: book-page.with(title: "躓いたこと")

= はじめに

沼ったポイントの紹介です。
本文を最初から読んでない前提で書いているので本文中の内容も含みます。
Rust知らんが勉強してそのうち直したい。

= media系

== `--allowrd-url-source`を設定していない

初期状態ではmediaのsrcに埋め込めるのは`^(player.bilibili.com)$`に一致する*ドメイン*のみです @noauthor_shiroaclisrclibrs_nodate 。
特別な理由がない限り`--allowed-url-source ".*"`して制限を解除した方がいいと思います。

== 許可されていない属性を足している

使用可能な属性は厳密に定められています。
使用不可能な属性をarrtibutesで指定した場合、その時点でそのmediaを破棄するようなので注意してください @noauthor_shiroaclisrcrendertypstrs_nodate 。

== 埋め込み直下にでかいスペースができる

audio, videoで生じているように見えます。
原因も解決方法もよく分かっていません。解決方法募集中です。
応急処置としては`outer-width`と`outer-height`をいい感じに設定するなどがあります。
値を小さくしすぎるとプレイヤーの下にテキストが潜るので注意。

== 埋め込んだコンテンツに対する操作ができない

原因も解決方法もよく分かっていません。解決方法募集中です。
一時的な対策として三つの方法を見つけました。

+ mediaの前後にpagebreakを挟む

  linebreakやcolbreak、その他contextで囲ったりなんか色々しましたがpagebreakだけが有効でした。

  注意点としてfigureやcolumnではpagebreakが使えないという点とfootnoteがbreak後に挿入されるというものがありますがそれらを使わないなら一番楽でいい選択だと思います。

+ ビルド後、適当なCSSで対象に```css position: absolute ; z-index: 2;```を適用（当サイトで採用）

  attributesでclassを指定できるので適当なclassを付けて`dist/theme/css/general.css`の最後に書き込むようにしています。
  書き込んだ内容はビルドするたびに消えることに注意

+ ビルド後、対象の一個、もしくは二個親のclassを`typst-html-semantics`にする

  直そうとしている時に見つけました。うまくいく理由も分からないし変更もだるいのでお勧めしません。

= HTMLに反映されていない

== imageのalt

#cross-link(
  "/Typstの諸機能表示テスト/Typstの諸機能表示テスト.typ",
  reference: heading-reference[== 画像]
  )[Typstの諸機能表示テストの画像テスト]で気がついたけどimageのaltが反映されていない。

#figure(caption: [imgタグにaltがないことが確認できる],
  image("imageのaltが反映されない.png", alt: "Chromeデベロッパーツール。imgタグにaltがないことが確認できる")
)

== book-metaのdescription

```typ
#book-meta(description: "サイトの説明",)
```

@noauthor_shiroa_nodate では各ページの`<head>`タグにメタ情報として追加されるものとして説明されていますが、実際は各ページの冒頭が自動で格納されているようです。

#bibliography("つまずいたとこ.bib")
