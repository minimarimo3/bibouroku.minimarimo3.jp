#import "@preview/shiroa:0.1.2": *

#show: book


#book-meta(
  language: "ja-JP",
  // repository: "https://github.com/minimarimo3/bibouroku.minimarimo3.jp",
  repository: "https://github.com/minimarimo3/bibouroku.minimarimo3.jp/blob/main/備忘録を公開する/{path}",
  repository-edit: "https://forms.gle/MktutcwRWKc4mBC58",
  title: "Typstで書いた備忘録を公開する",
  description: "何かやってます",
  summary: [
    #prefix-chapter("はじめに.typ", "はじめに")

    = 調査
    #chapter("公開に使えるツール/公開に使えるツール.typ", "公開に使えるツール")

    = shiroa
    #chapter("Typstの諸機能表示テスト/Typstの諸機能表示テスト.typ", "Typstの諸機能表示テスト")
    #chapter("shiroa独自の機能/shiroa独自の機能.typ", "shiroa独自の機能")
    #chapter("テンプレートを作成する/テンプレートを作成する.typ", "テンプレートを作成する")
    #chapter("つまずいたこと/つまずいたこと.typ", "つまずいたこと")

    = GitHub Pagesで公開する
    #chapter("GitHub Pagesで公開する/GitHub Pagesで公開する.typ", "GitHub Pagesで公開する")
  ]
)

// re-export page template
#import "/templates/page.typ": project, heading-reference, TODO, embedYT

#let book-page = project
