#import "/typst/core/shared.typ": d, main-font
#import "/typst/generated/posts.typ": post-data
#import "/typst/components/head.typ": common-head
#import "/typst/components/widgets.typ": widget-author

#let diary(
  slug: none,
  title: "日記",
  authors: ("minimarimo3",),
  create: none,
  update: none,
  tags: ("日記",),
  description: none,
  og-image: none,
  draft: false,
  mood: none,
  health: none,
  ..args,
  body,
) = context {
  set document(title: title, author: authors)
  set text(lang: "ja", font: main-font)

  if target() == "paged" {
    set text(font: main-font, size: 12pt)
    body
    return
  }

  assert(slug != none, message: "slugは書く")
  assert(description != none, message: "descriptionは書く")
  assert(create != none, message: "createは書く")

  html.html(lang: "ja", {
    html.head({
      common-head(title, description: description, image: og-image)
    })
    html.body({
      html.div(class: "site-container", {
        html.main(class: "main-content", {
          html.article({
            html.header(class: "article-header", {
              html.a(class: "back-home-btn", href: "/", "← ホームに戻る")
              html.h1(class: "article-title", title)
              html.div(class: "article-meta", {
                html.div(class: "meta-dates", {
                  html.span(class: "meta-date", create.display("[year]-[month]-[day]"))
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

            if mood != none or health != none {
              html.div(class: "diary-status", {
                if mood != none {
                  html.span(class: "diary-status-item", "気分: " + mood)
                }
                if health != none {
                  html.span(class: "diary-status-item", "体調: " + health)
                }
              })
            }

            html.div(class: "article-body", body)
          })
        })

        html.aside(class: "sidebar", {
          html.div(class: "sidebar-inner", {
            widget-author()
          })
        })
      })
    })
  })
}
