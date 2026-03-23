#import "/typst/core/shared.typ": main-font
#import "/typst/components/head.typ": common-head
#import "/typst/components/widgets.typ": widget-author, widget-about

#let home(
  title: "ブログタイトル",
  authors: ("minimarimo3",),
  description: "ブログの説明文",
  og-image: none,
  posts: none,
  body,
) = context {
  set document(title: title, author: authors)
  set text(lang: "ja")

  if target() == "paged" {
    set text(font: main-font, size: 12pt, lang: "ja")
    body
    return
  }

  html.html(lang: "ja", {
    html.head({
      common-head(title, description: description, image: og-image)
    })
    html.body({
      html.div(class: "site-container", {
        html.main(class: "main-content", {
          html.header(class: "article-header", {
            html.h1(class: "article-title", title)
            if description != "" {
              html.p(style: "color: var(--text-muted);", description)
            }
          })

          html.div(class: "card-grid", {
            let posts-list = if posts != none {
              posts
                .pairs()
                .map(pair => {
                  let (key, val) = pair
                  val + (url: "/" + key + "/")
                })
                .sorted(key: p => p.create)
                .rev()
            } else {
              ()
            }

            for post in posts-list {
              html.a(class: "post-card", href: post.url, {
                html.div(class: "card-content", {
                  if "create" in post {
                    html.time(class: "card-date", post.create.display("[year]-[month]-[day]"))
                  }
                  html.h3(class: "card-title", post.title)
                  if "description" in post {
                    html.p(class: "card-desc", post.description)
                  }
                  if "tags" in post and post.tags != none {
                    html.div(class: "meta-tags", {
                      for tag in post.tags {
                        html.span(class: "tag", "#" + tag)
                      }
                    })
                  }
                })
              })
            }
          })
        })

        html.aside(class: "sidebar", {
          html.div(class: "sidebar-inner", {
            widget-author()
            widget-about()
          })
        })
      })
    })
  })
}
