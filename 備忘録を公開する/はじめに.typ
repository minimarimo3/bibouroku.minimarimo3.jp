#import "/book.typ": book-page

#show: book-page.with(title: "はじめに")

= 概要

あれです

= 環境

#table(columns: 2,
  table.header("対象", "バージョン"),
  "shiroa", "shiroa version 0.2.0(features: embedded_fonts)",
  "Typst", "0.12.0",
)

= 最終的な目標

GitHub Pagesにいい感じ#[#emoji.tm]なサイトが構築されること。
