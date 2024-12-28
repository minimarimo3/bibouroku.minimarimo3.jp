#import "@preview/shiroa:0.1.2": *

#show: book


#book-meta(
  title: "Typstで書いた備忘録を公開する",
  summary: [
    #prefix-chapter("はじめに.typ", "はじめに")

    = 事前調査
    #chapter("公開に使えるツール/公開に使えるツール.typ", "公開に使えるツール")
    #chapter("検索に使えるツール/検索に使えるツール.typ", "検索に使えるツール")

    = 構築
    == shiroa
    #chapter(none, "shiroaとは何か")
    #chapter(none, "Typstの諸機能表示テスト")
    #chapter(none, "設定")
    == 何か適当な検索ツール
    #chapter(none, "何を使おうか？")

    #suffix-chapter(none, "まとめ")
  ]
)



// re-export page template
#import "/templates/page.typ": project
#let book-page = project
