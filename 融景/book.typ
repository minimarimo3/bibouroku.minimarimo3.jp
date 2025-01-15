/*
#import "../templates/page.typ": project, embedYT, TODO

#show : project.with(
  datetime(year: 2025, month: 01, day: ),
  title: ""
)
*/


#import "@preview/shiroa:0.1.2": *

#show: book

#book-meta(
  title: "shiroa",
  summary: [
    #prefix-chapter("はじめに/はじめに.typ", "はじめに")

    = 構想・理想像
    #chapter("最終的にできてほしいもの/最終的にできてほしいもの.typ", "最終的にできてほしいもの")
    #chapter("とりあえず作るもの/とりあえず作るもの.typ", "とりあえず作るもの")
    = 調査
    #chapter("参考になりそうなもの/参考になりそうなもの.typ", "参考になりそうなもの")
  ]
)



// re-export page template
#import "/templates/page.typ": project
#let book-page = project
