#import "@preview/shiroa:0.1.2": *

#show: book


#book-meta(
  language: "ja-JP",
  repository: "https://github.com/minimarimo3/bibouroku.minimarimo3.jp",
  repository-edit: "https://forms.gle/MktutcwRWKc4mBC58",
  title: "Typstで書いた備忘録を公開する",
  summary: [
    #prefix-chapter("はじめに.typ", "はじめに")

    = 事前調査
    #chapter("公開に使えるツール/公開に使えるツール.typ", "公開に使えるツール")

    = 構築
    == shiroa
    #chapter(none, "shiroaとは何か")
    // #chapter("shiroaとは何か/shiroaとは何か.typ", "shiroaとは何か")
    #chapter("Typstの諸機能表示テスト/Typstの諸機能表示テスト.typ", "Typstの諸機能表示テスト")
    #chapter("shiroa独自の機能/shiroa独自の機能.typ", "shiroa独自の機能")
    #chapter("テンプレートを作成する/テンプレートを作成する.typ", "テンプレートを作成する")
    #chapter("躓いたこと/躓いたこと.typ", "躓いたこと")

    #suffix-chapter(none, "まとめ")
  ]
)

// re-export page template
#import "/templates/page.typ": project, heading-reference, TODO
#let book-page = project
