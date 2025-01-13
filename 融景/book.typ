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
  ]
)



// re-export page template
#import "/templates/page.typ": project
#let book-page = project
