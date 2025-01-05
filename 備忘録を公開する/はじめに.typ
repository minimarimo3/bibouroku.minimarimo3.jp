#import "/book.typ": book-page, cross-link

#show: book-page.with(title: "はじめに")

= 概要

この文章は実際にshiroaを使い、GitHub Pagesで公開するために行った作業の備忘録です。

GitHub Pagesにいい感じ#[#emoji.tm]なサイトが構築されることを目指してツールを探しました。

その結果、Typstを公開する方法として以下の三つを見つけました。
+ Typst公式によるHTML出力（現在開発中）
+ Pandocによる他フォーマットへの変換
+ Tinymistの作者様が作った#link("https://github.com/Myriad-Dreamin/shiroa")[shiroa]という静的サイトジェネレーター

魅力的なSSGがあるならということで、私はshiroaを採用しました。
#footnote([
  この文章もshiroaによってウェブブラウザから閲覧できるようになっています。
])

#cross-link("/Typstの諸機能表示テスト/Typstの諸機能表示テスト.typ")[Typstの諸機能表示テスト]では、Typstで使用できる関数・数式・参考文献等がどのように表示されるかを簡単に確認できます。

#cross-link("/shiroa独自の機能/shiroa独自の機能.typ")[shiroa独自の機能]では、他ファイルへのリンクやサイト埋め込み機能などの使い方を簡単に確認できます。

#cross-link("/テンプレートを作成する/テンプレートを作成する.typ")[テンプレートを作成する]では、このサイトで使用しているTypstテンプレートを公開しています。

#cross-link("/つまずいたこと/つまずいたこと.typ")[つまずいたこと]では、いくつかのバグや注意点を紹介しています。
例えば、shiroaでbilibiliしか読み込めない、あるいは埋め込みはできたもののプレイヤーがクリックできない問題などは、ここを読めば解決できるかもしれません。

#cross-link("/GitHub Pagesで公開する/GitHub Pagesで公開する.typ")[GitHub Pagesで公開する]では、このサイトが使用しているGitHub Actionsを公開しています。

内容に不備等ある場合は右上の鉛筆マークから連絡お願いします。

= 環境

#table(columns: 2,
  table.header("対象", "バージョン"),
  "shiroa", "0.2.0(features: embedded_fonts)",
  "Typst", "0.12.0",
)
