#import "/typst/core/shared.typ": d, main-font
#import "/typst/generated/posts.typ": post-data
#import "/typst/components/head.typ": common-head
#import "/typst/components/widgets.typ": widget-author
#import "@preview/suiji:0.5.0": *

#let env(..items) = context {
  heading(outlined: false, numbering: none)[執筆環境]

  table(
    columns: (auto, auto, 1fr),
    inset: 8pt,
    align: horizon,
    stroke: (x, y) => if y == 0 { (bottom: 1pt + black) } else { (bottom: 0.5pt + gray) },
    table.header([ソフト名], [バージョン], [補足]),
    ..items
      .pos()
      .map(item => (
        item.at(0),
        item.at(1),
        item.at(2, default: [---]),
      ))
      .flatten(),
  )
}

#let article(
  slug: none,
  title: "ブログタイトル",
  authors: ("minimarimo3",),
  create: none,
  update: none,
  tags: (),
  description: none,
  og-image: none,
  feedback_url: "https://docs.google.com/forms/d/e/1FAIpQLSdyN8Q-zohUmlOxASKnJjwSSgs-S0PkHZMXDg2Zh8GgSTgOkQ/viewform",
  feedback_entry_id: "entry.629693238",
  draft: false,
  ..args,
  body,
) = context {
  set document(title: title, author: authors)
  set heading(numbering: "1.")
  set text(lang: "ja")
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: raw): set figure(supplement: "コード")

  if target() == "paged" {
    set text(font: main-font, size: 12pt)
    body
    return
  }

  assert(slug != none, message: "slugは書く")
  assert(description != none, message: "descriptionは書く")

  let note-counter = counter("my-footnote")
  show footnote: it => {
    note-counter.step()
    let num = note-counter.get().first() + 1
    html.span(class: "footnote-wrapper", {
      html.span(class: "footnote-marker", "※" + str(num))
      html.span(class: "footnote-content", it.body)
    })
  }

  show math.equation.where(block: false): it => {
    html.elem("span", attrs: (role: "math"), html.frame(it))
  }
  show math.equation.where(block: true): it => {
    html.elem("figure", attrs: (role: "math"), html.frame(it))
  }

  html.html(lang: "ja", {
    html.head({
      common-head(title, description: description, image: og-image)
    })
    html.body({
      html.div(id: "copy-toast", "コピーしました！")
      html.div(class: "site-container", {
        html.main(class: "main-content", {
          html.article({
            html.header(class: "article-header", {
              html.a(class: "back-home-btn", href: "/", "← ホームに戻る")
              html.h1(class: "article-title", title)
              html.div(class: "article-meta", {
                html.div(class: "meta-dates", {
                  if create != none {
                    html.span(class: "meta-date", "文書作成日: " + create.display("[year]-[month]-[day]"))
                  }
                  if update != none {
                    html.span(class: "meta-date", "最終更新日: " + update.display("[year]-[month]-[day]"))
                  }
                  html.a(class: "meta-pdf-link", href: "index.pdf", target: "_blank", "PDF")
                })
                if tags.len() > 0 {
                  html.div(class: "meta-tags", {
                    for tag in tags {
                      html.span(class: "tag", "#" + tag)
                    }
                  })
                }
              })
            })

            html.div(class: "mobile-toc", {
              html.details({
                html.summary("目次を開く")
                outline(title: none)
              })
            })

            if description != "" {
              html.div(class: "article-abstract", {
                html.strong(class: "abstract-title", "概要")
                html.p(description)
              })
            }

            html.div(class: "article-body", body)
          })

          html.section(class: "share-feedback-section", {
            html.hr(class: "section-divider")
            html.div(class: "share-area", {
              html.h3("この記事をシェアする")
              html.div(class: "share-buttons", {
                html.elem("button", attrs: (class: "share-btn btn-x", onclick: "shareX()"), "Xでポスト")
                html.elem("button", attrs: (class: "share-btn btn-misskey", onclick: "shareMisskey()"), "Misskeyでノート")
                html.elem("button", attrs: (class: "share-btn btn-copy", onclick: "copyInfo()"), "タイトルと概要をコピー")
              })
            })

            if feedback_url != none {
              html.div(class: "feedback-area", {
                html.h3("ご意見・ご感想")
                html.p("記事に関するご意見や誤字の報告などをお待ちしています。")
                html.elem(
                  "button",
                  attrs: (
                    class: "feedback-link",
                    onclick: "openFeedback('" + feedback_url + "', '" + feedback_entry_id + "')",
                  ),
                  "Googleフォームで送る",
                )
              })
            }
          })

          assert(create != none, message: "createは書く")
          let other-posts = post-data
            .pairs()
            .filter(p => p.first() != slug)
            .filter(p => p.last().create < create)
          if other-posts.len() > 0 {
            html.hr(class: "section-divider")

            html.section(class: "related-posts", {
              html.h2(class: "section-title", "その他の記事")
              let seed-src = slug + title
              let seed = int(seed-src.clusters().map(str.to-unicode).map(str).join().slice(0, calc.min(14, seed-src.clusters().len())))
              let rng = gen-rng(seed)
              let (_, indices) = shuffle-f(rng, range(other-posts.len()))
              let picks = indices.slice(0, calc.min(3, indices.len())).map(i => other-posts.at(i))

              html.div(class: "card-grid", {
                for pair in picks {
                  let (other-slug, post) = pair
                  let url = "/" + other-slug + "/"
                  html.a(class: "post-card", href: url, {
                    html.div(class: "card-content", {
                      if "create" in post {
                        html.time(class: "card-date", post.create.display("[year]-[month]-[day]"))
                      }
                      html.h3(class: "card-title", post.title)
                      if "description" in post {
                        html.p(class: "card-desc", post.description)
                      }
                    })
                  })
                }
              })
            })
          }
        })

        html.aside(class: "sidebar", {
          html.div(class: "sidebar-inner", {
            html.div(class: "sidebar-widget toc-widget", {
              html.h3(class: "widget-title", "目次")
              outline(title: none)
            })
            widget-author()
          })
        })
      })
    })
  })
}
