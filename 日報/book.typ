/*
#import "/note.typ": 日報

#show : 本文 => 日報(
  執筆日: datetime(year: 2025, month: , day: ),
  今日やったこと: [

  ],
  今日あった嬉しかったこと: [

  ],
  明日やりたいこと: [

  ],
  その他: none
)
*/

#import "@preview/shiroa:0.1.2": *

#show: book


#let n = (date) => {
  return chapter(section: none, str(date) + ".typ", date)
}

#book-meta(
  title: "日報",
  summary: [
    #prefix-chapter(none, "日報")

    = 2025
    #n("25-01-05")
    #n("25-01-04")
    #n("25-01-03")
    #n("25-01-02")
    #chapter(section: none, "25-01-01.typ", "25-01-01🎍")

    = 2024
    #n("24-12-31")
    #n("24-12-30")
  ]
)


// re-export page template
#import "/templates/page.typ": project, embedYT
#let book-page = project
