/*
#import "../template.typ": project, note, note, tip, important, warning, caution, env
#import "../posts.typ": post-data
#let meta = post-data.at("")
#show: project.with(..meta)
*/

// フォントは0.14時点ではHTMLだと反映されません。
#let main-font = ("Noto Serif JP", "Hiragino Mincho ProN", "serif")
#let code-font = ("Fira Code", "Consolas", "monospace")

#import "/posts.typ": post-data
#import "@preview/suiji:0.5.0": *

// 引数のHTMLをJSで直接埋め込む関数
//  サイトの埋め込み(iframe)とかで使うと便利
#let raw_html(content) = {
  // HTML側で置換するためのプレースホルダーdivを作る
  // data-html属性に生のコードを退避させておく
  html.elem("div", attrs: (
    class: "raw-html-embed",
    "data-html": content.text
  ))
}

// 執筆時の環境を簡単に書くためのもの。
//  (ソフト名, バージョン, 補足（任意）)を受け付ける
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


// 共通のラッパー関数
#let _alert-box(kind, title, icon, body) = context {
  if target() == "paged" {
    return icon + " " + title + ": " + body;
  }
  html.div(class: "markdown-alert markdown-alert-" + kind, {
    html.p(class: "markdown-alert-title", {
      html.span(class: "markdown-alert-icon", icon)
      title
    })
    html.div(class: "markdown-alert-content", body)
  })
}

// ユーザーが使うショートカット関数
#let note(body) = _alert-box("note", "補足", "ℹ️", body)
#let tip(body) = _alert-box("tip", "ヒント", "💡", body)
#let important(body) = _alert-box("important", "重要", "📢", body)
#let warning(body) = _alert-box("warning", "注意", "⚠️", body)
#let caution(body) = _alert-box("caution", "警告", "🛑", body)

// YouTube動画のレスポンシブ埋め込み用関数 (URL自動パース対応版)
#let youtube(url-or-id, start: none) = context {
  // 正規表現で様々な形式のYouTube URLから11桁の動画IDを抽出する
  // 対応パターン:
  // - https://www.youtube.com/watch?v=ID
  // - https://youtu.be/ID
  // - https://www.youtube.com/embed/ID
  // - プレイリスト等が含まれるURL (例: watch?v=ID&list=...)
  let m = url-or-id.match(regex("(?:v=|youtu\.be/|embed/)([a-zA-Z0-9_-]{11})"))
  
  let clean-id = if m != none {
    // 正規表現にマッチした場合は、キャプチャグループ1（ID部分）を取得
    m.captures.at(0)
  } else {
    // マッチしない場合（IDのみが直接渡された場合などを想定）のフォールバック
    url-or-id.split("?").at(0).split("&").at(0)
  }

  // クエリパラメータの構築
  let query-params = ()
  if start != none {
    query-params.push("start=" + str(start))
  }

  let query-string = if query-params.len() > 0 {
    "?" + query-params.join("&")
  } else {
    ""
  }

  let embed-url = "https://www.youtube.com/embed/" + clean-id + query-string

  // PDF出力時のフォールバック処理
  if target() == "paged" {
    return [
      #align(center)[
        #rect(inset: 10pt, stroke: luma(150), radius: 4pt)[
          ▶ YouTube動画: #link("https://youtu.be/" + clean-id)
        ]
      ]
    ]
  }
  
  // HTML出力時
  html.div(class: "video-wrapper", {
    html.elem("iframe", attrs: (
      src: embed-url,
      title: "YouTube video player",
      frameborder: "0",
      allow: "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share",
      allowfullscreen: ""
    ))
  })
}

// --- アイコンデータ (Simple Icons) ---
#let icons = (
  // X (https://simpleicons.org/?q=X&modal=icon)
  x: `<svg role="img" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><title>X</title><path d="M14.234 10.162 22.977 0h-2.072l-7.591 8.824L7.251 0H.258l9.168 13.343L.258 24H2.33l8.016-9.318L16.749 24h6.993zm-2.837 3.299-.929-1.329L3.076 1.56h3.182l5.965 8.532.929 1.329 7.754 11.09h-3.182z"/></svg>`.text,
  
  // Misskey(https://simpleicons.org/?q=misskey&modal=icon)
  //  The Misskey logo is a trademark of the Misskey project, licensed under CC BY-NC-SA 4.0.
  misskey: `<svg role="img" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><title>Misskey</title><path d="M8.91076 16.8915c-1.03957.0038-1.93213-.6294-2.35267-1.366-.22516-.3217-.66989-.4364-.6761 0v2.0148c0 .8094-.29152 1.5097-.87581 2.1002-.56755.573-1.25977.8595-2.0779.8595-.80014 0-1.49298-.2865-2.07727-.8601C.28408 19.05 0 18.3497 0 17.5403V6.45968c0-.62378.17553-1.18863.52599-1.69455.36657-.52284.83426-.88582 1.4018-1.08769a2.84574 2.84574 0 0 1 1.00049-.17742c.90125 0 1.65239.35421 2.25281 1.06262l2.99713 3.51572c.06699.05016.263.43696.73192.43696.47016 0 .6916-.3868.75796-.43758l2.9717-3.5151c.6178-.70841 1.377-1.06262 2.2782-1.06262.3337 0 .6675.05893 1.0012.17742.5669.20187 1.0259.56422 1.377 1.08769.3665.50592.5501 1.07077.5501 1.69455V17.5403c0 .8094-.2915 1.5097-.8758 2.1002-.5675.573-1.2604.8595-2.0779.8595-.8008 0-1.493-.2865-2.0779-.8601-.5669-.5899-.8504-1.2902-.8504-2.0996v-2.0148c-.0496-.5499-.5303-.2032-.7009 0-.4503.8431-1.31369 1.3616-2.35264 1.366ZM21.447 8.60998c-.7009 0-1.3015-.24449-1.8019-.73348-.4838-.50571-.7257-1.11277-.7257-1.82118s.2419-1.30711.7257-1.79611c.5004-.50571 1.101-.75856 1.8019-.75856.7009 0 1.3017.25285 1.8025.75856.5003.489.7505 1.0877.7505 1.79611 0 .70841-.2502 1.31547-.7505 1.82118-.5008.48899-1.1016.73348-1.8025.73348Zm.0248.50655c.7009 0 1.2935.25285 1.7777.75856.5003.50571.7505 1.11301.7505 1.82181v6.2484c0 .7084-.2502 1.3155-.7505 1.8212-.4838.489-1.0764.7335-1.7777.7335-.7005 0-1.3011-.2445-1.8019-.7335-.5003-.5057-.7505-1.1128-.7505-1.8212v-6.2484c0-.7084.2502-1.3157.7505-1.82181.5004-.50571 1.101-.75856 1.8019-.75856Z"/></svg>`.text,
  
  // GitHub(https://simpleicons.org/?q=github&modal=icon)
  github: `<svg role="img" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><title>GitHub</title><path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/></svg>`.text
)

#let common-head(title, description: none, image: none) = {
    html.meta(charset: "utf-8")
    html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
    html.title(title)
    
    // Google Fonts
    html.link(rel: "preconnect", href: "https://fonts.googleapis.com")
    html.link(rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous")
    html.link(
      rel: "stylesheet",
      href: "https://fonts.googleapis.com/css2?family=Fira+Code:wght@300..700&family=Noto+Serif+JP:wght@400;700&display=swap",
    )
    
    // 共通CSS
    html.link(rel: "stylesheet", href: "/style.css")
    html.script(src: "/script.js")
    
    // Cloudflare Web Analytics
    html.elem(
      "script",
      attrs: (
        defer: "",
        src: "https://static.cloudflareinsights.com/beacon.min.js",
        data-cf-beacon: "{\"token\": \"4b32234cfe9741ea8a4437f109f7b029\"}",
      )
    )

    // OGP & Description
    if description != none and description != "" {
      html.meta(name: "description", content: description)
    }
    html.elem("meta", attrs: (property: "og:title", content: title))
    if image != none {
      html.elem("meta", attrs: (property: "og:image", content: image))
    }
}

#let widget-author(
  author: "minimarimo3",
  message: [その辺の大学生],
  socials: (
    x: "https://x.com/minimarimo3",
    misskey: "https://misskey.io/@minimarimo3",
    github: "https://github.com/minimarimo3",
  ),
) = {
  html.div(class: "sidebar-widget", {
    html.h3(class: "widget-title", "執筆者")
    html.strong(author)
    html.p(
      style: "font-size: 0.85rem; color: var(--text-muted); margin-top: 0.5em;",
      message,
    )
    if socials != none {
      html.div(class: "author-links", {
        if "x" in socials {
          html.a(class: "author-icon-link", href: socials.x, target: "_blank", {
            html.elem("div", attrs: (class: "raw-html-embed icon-x", "data-html": icons.x))
          })
        }
        if "misskey" in socials {
          html.a(class: "author-icon-link", href: socials.misskey, target: "_blank", {
            html.elem("div", attrs: (class: "raw-html-embed icon-misskey", "data-html": icons.misskey))
          })
        }
        if "github" in socials {
          html.a(class: "author-icon-link", href: socials.github, target: "_blank", {
            html.elem("div", attrs: (class: "raw-html-embed icon-github", "data-html": icons.github))
          })
        }
      })
    }
  })
}

#let widget-about() = {
  html.div(class: "sidebar-widget", {
    html.h3(class: "widget-title", "本ブログについて")
    html.p(
      style: "font-size: 0.85rem; color: var(--text-muted); margin-top: 0.5em;",
      [
        本サイトの内容は特に記載がない限り#link("https://www.wtfpl.net")[WTFPL]の元で提供されます。
        また、アクセス解析のために#link("https://www.cloudflare.com/ja-jp/web-analytics/")[Cloudflare Web Analytics]を使用しています。このツールはCookieを使用せず、個人を特定する情報は収集されません。
        サイトに関するご意見は#link("https://forms.gle/hhLGvUeWKyNK1UUz6")[Googleフォーム]までお願いします。

        #link("https://simpleicons.org/?q=misskey&modal=icon")[シェアボタンのMisskeyアイコン]はMisskey projectによってCC-BY-NC-SA-4.0で提供されています。
      ],
    )
  })
}


#let project(
  title: "ブログタイトル",
  authors: ("minimarimo3",),
  create: none,
  update: none,
  tags: (),
  description: none,
  og-image: none,
  feedback_url: "https://docs.google.com/forms/d/e/1FAIpQLSdyN8Q-zohUmlOxASKnJjwSSgs-S0PkHZMXDg2Zh8GgSTgOkQ/viewform",
  feedback_entry_id: "entry.629693238",
  related_posts: (),
  ..args,
  body,
) = context {
  // PDF/HTML共通設定
  set document(title: title, author: authors)
  set heading(numbering: "1.")
  set text(lang: "ja")
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: raw): set figure(supplement: "コード")
  
  if target() == "paged" {
    // Typst 0.14ではフォントやそのサイズは反映されない。
    // ビルド時にwarningが出てうっとおしいのでフォントはここで設定する
    set text(font: main-font, size: 12pt)
    body
    return
  }
  
  assert(description != none, message: "descriptionは書く")
  
  // 脚注 (CSSツールチップ用)
  let note-counter = counter("my-footnote")
  show footnote: it => {
    note-counter.step()
    let num = note-counter.get().first() + 1
    html.span(class: "footnote-wrapper", {
      html.span(class: "footnote-marker", "※" + str(num))
      html.span(class: "footnote-content", it.body)
    })
  }
  
  // v0.14では数式のエクスポートができないため数式をSVG画像化して対応する
  //  https://github.com/typst/typst/issues/721#issuecomment-2817289426
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
        // --- メインカラム ---
        html.main(class: "main-content", {
          html.article({
            // 記事ヘッダー
            html.header(class: "article-header", {
              html.a(class: "back-home-btn", href: "/", "← ホームに戻る")
              html.h1(class: "article-title", title)
              
              // メタデータ (日付・タグ)
              html.div(class: "article-meta", {
                html.div(class: "meta-dates", {
                  if create != none {
                    html.span(class: "meta-date", "文書作成日: " + create.display("[year]-[month]-[day]"))
                  }
                  if update != none {
                    html.span(
                      class: "meta-date",
                      "最終更新日: " + update.display("[year]-[month]-[day]"),
                    )
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
            
            // 本文
            html.div(class: "article-body", body)
          })
          
          
          html.section(class: "share-feedback-section", {
            html.hr(class: "section-divider")
            
            // シェアボタン
            html.div(class: "share-area", {
              html.h3("この記事をシェアする")
              html.div(class: "share-buttons", {
                html.elem("button", attrs: (class: "share-btn btn-x", onclick: "shareX()"), "Xでポスト")
                html.elem(
                  "button",
                  attrs: (class: "share-btn btn-misskey", onclick: "shareMisskey()"),
                  "Misskeyでノート",
                )
                html.elem(
                  "button",
                  attrs: (class: "share-btn btn-copy", onclick: "copyInfo()"),
                  "タイトルと概要をコピー",
                )
              })
            })
            
            // フィードバック
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
          
          assert(create != none)
          let other-posts = post-data.pairs().filter(p => p.last().title != title).filter(p => p.last().create < create)
          if other-posts.len() > 0 {
            // 関連記事エリア
            html.hr(class: "section-divider")
            
            html.section(class: "related-posts", {
              html.h2(class: "section-title", "その他の記事")
              // 記事タイトルをシードにしてシャッフル（リビルドしても結果が変わらないようにする）
              let rng = gen-rng(int(title.clusters().map(str.to-unicode).map(str).join().slice(0, calc.min(14, title.clusters().len()))))
              let (_, indices) = shuffle-f(rng, range(other-posts.len()))
              // 最大3件を取得
              let picks = indices.slice(0, calc.min(3, indices.len())).map(i => other-posts.at(i))
              
              html.div(class: "card-grid", {
                for pair in picks {
                  let (dir, post) = pair
                  let url = "/" + dir + "/"
                  
                  html.a(class: "post-card", href: url, {
                    html.div(class: "card-content", {
                      if "create" in post {
                        html.time(class: "card-date", post.create.display("[year]-[month]-[day]"))
                      }
                      html.h3(class: "card-title", post.title)
                      if "description" in post { html.p(class: "card-desc", post.description) }
                    })
                  })
                }
              })
            })
          }
        })
        
        // --- サイドバー ---
        html.aside(class: "sidebar", {
          html.div(class: "sidebar-inner", {
            // 目次ウィジェット
            html.div(class: "sidebar-widget toc-widget", {
              html.h3(class: "widget-title", "目次")
              outline(title: none)
            })
            
            // 著者プロフィールウィジェット
            widget-author()
          })
        })
      }) // end .site-container
    })
  })
}



// --- 記事一覧ページ（トップページ）用テンプレート ---
#let home(
  title: "ブログタイトル",
  authors: ("minimarimo3",),
  description: "ブログの説明文",
  og-image: none,
  posts: none,
  body,
) = context {
  // 文書設定
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
        // --- メインコンテンツ ---
        html.main(class: "main-content", {
          // ブログヘッダー
          html.header(class: "article-header", {
            html.h1(class: "article-title", title)
            if description != "" {
              html.p(style: "color: var(--text-muted);", description)
            }
          })
          
          // 記事一覧 (カードグリッド)
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
                  // 日付
                  if "create" in post {
                    html.time(class: "card-date", post.create.display("[year]-[month]-[day]"))
                  }
                  
                  // タイトル
                  html.h3(class: "card-title", post.title)
                  
                  // 説明文
                  if "description" in post {
                    html.p(class: "card-desc", post.description)
                  }
                  
                  // タグ (あれば表示)
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
        
        // --- サイドバー ---
        html.aside(class: "sidebar", {
          html.div(class: "sidebar-inner", {
            // 著者プロフィール
            widget-author()
            
            // ブログについて
            widget-about()
          })
        })
      }) // end .site-container
    })
  })
}


// https://typst.app/docs/reference/visualize/image/#:~:text=Supported%20formats%20are%20%22png%22%2C%20%22jpg%22%2C%20%22gif%22%2C%20%22svg%22%2C%20%22pdf%22%2C%20%22webp%22%20as%20well%20as%20raw%20pixel%20data.
#let image-extensions = (
  ".png", ".jpg", ".jpeg", ".gif", ".svg", ".pdf", ".webp"
)

// リンクまたは画像に変換する関数
#let link-or-image(raw-text) = context {
  let content = raw-text.trim("|")
  let parts = content.split(", ")
  let path-str = parts.at(0).trim()
  
  let alias-text = none
  if parts.len() > 1 {
    alias-text = parts.slice(1).join(", ").trim()
  }

  let is-image = false
  for ext in image-extensions {
    if path-str.ends-with(ext) {
      is-image = true
      break
    }
  }

  if is-image {
    if alias-text != none {
      image(path-str, alt: alias-text)
    } else {
      image(path-str)
    }
  } else {
    let target-path = path-str
    if not target-path.ends-with(".typ") {
      target-path = target-path + if target() == "html" {".html"} else {".typ"}
    }

    let display-content = if alias-text != none { alias-text } else { raw-text.trim("|") }

    link(target-path)[
      #set text(fill: rgb("#0000EE")) 
      #display-content
    ]
  }
}

// ユーザーが呼び出すメイン関数
#let pkm(body) = {
  show regex("\|[^\|\n]+\|"): it => {
    link-or-image(it.text)
  }
  body
}