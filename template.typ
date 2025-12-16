// フォントは0.14時点ではHTMLだと反映されません。
#let main-font = ("Noto Serif JP", "Hiragino Mincho ProN", "serif")
#let code-font = ("Fira Code", "Consolas", "monospace")

#import "/posts.typ": post-data
#import "@preview/suiji:0.5.0": *

// 共通のラッパー関数
#let _alert-box(kind, title, icon, body) = {
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


#let project(
  title: "ブログタイトル",
  authors: ("minimarimo3",),
  tags: (),
  description: none,
  og-image: none,
  feedback_url: "https://docs.google.com/forms/d/e/1FAIpQLSdyN8Q-zohUmlOxASKnJjwSSgs-S0PkHZMXDg2Zh8GgSTgOkQ/viewform",
  feedback_entry_id: "entry.629693238",
  create: none,
  update: none,
  related_posts: (),
  ..args,
  body,
) = context {
  // PDF/HTML共通設定
  set document(title: title, author: authors)
  set text(font: main-font, size: 12pt, lang: "ja")
  set heading(numbering: "1.")
  
  // 図表の設定
  show figure.where(kind: table): set figure.caption(position: top)
  
  if target() == "paged" {
    body
    return
  }
  
  assert(description != none, message: "descriptionは書く")
  
  // 脚注 (CSSツールチップ用)
  let note-counter = counter("my-footnote")
  show footnote: it => {
    note-counter.step()
    let num = note-counter.get().first()
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
      html.meta(charset: "utf-8")
      html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
      html.title(title)
      
      // Google Fonts (Noto Serif JP & Fira Code)
      html.link(rel: "preconnect", href: "https://fonts.googleapis.com")
      html.link(rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous")
      html.link(
        rel: "stylesheet",
        href: "https://fonts.googleapis.com/css2?family=Fira+Code:wght@300..700&family=Noto+Serif+JP:wght@400;700&display=swap",
      )
      
      html.link(rel: "stylesheet", href: "/style.css")
      
      // OGPタグなど
      if description != "" {
        html.meta(name: "description", content: description)
      }
      html.elem("meta", attrs: (property: "og:title", content: title))
      
      html.script(
        "
        function shareX() {
          const url = encodeURIComponent(window.location.href);
          const text = encodeURIComponent(document.title);
          window.open(`https://twitter.com/intent/tweet?text=${text}&url=${url}`, '_blank');
        }
        function shareMisskey() {
          const url = encodeURIComponent(window.location.href);
          const text = encodeURIComponent(document.title);
          window.open(`https://misskey-hub.net/share/?text=${text}&url=${url}`, '_blank');
        }
        function openFeedback(url, entryId) {
          const title = document.title;
          // タイトルをURLエンコードしてパラメータに結合
          const fullUrl = `${url}?usp=pp_url&${entryId}=${encodeURIComponent(title)}`;
          window.open(fullUrl, '_blank');
        }
        function copyInfo() {
          const title = document.title;
          const desc = document.querySelector('meta[name=\"description\"]')?.content || '';
          const url = window.location.href;
          const textToCopy = `${title}\n${desc}\n${url}`;
          
          navigator.clipboard.writeText(textToCopy).then(() => {
            const toast = document.getElementById('copy-toast');
            toast.classList.add('show');
            setTimeout(() => toast.classList.remove('show'), 3000);
          });
        }
      ",
      )
    })
    
    html.body({
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
                    html.span(class: "meta-date", "文書作成日: " + create.display("[year repr:last_two]-[month]-[day]"))
                  }
                  if update != none {
                    html.span(
                      class: "meta-date",
                      "最終更新日: " + update.display("[year repr:last_two]-[month]-[day]"),
                    )
                  }
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
          
          let other-posts = post-data.pairs().filter(p => p.last().title != title)
          if other-posts.len() > 0 {
            // 関連記事エリア
            html.hr(class: "section-divider")
            
            html.section(class: "related-posts", {
              html.h2(class: "section-title", "その他の記事")
              // 記事タイトルをシードにしてシャッフル（リビルドしても結果が変わらないようにする）
              let rng = gen-rng(int(title.clusters().map(str.to-unicode).map(str).join().slice(0, 14)))
              let (_, indices) = shuffle-f(rng, range(other-posts.len()))
              // 最大3件を取得
              let picks = indices.slice(0, calc.min(3, indices.len())).map(i => other-posts.at(i))

              html.div(class: "card-grid", {
                for pair in picks {
                  let (dir, post) = pair
                  let url = "/" + dir + "/"

                  html.a(class: "post-card", href: url, {
                     html.div(class: "card-content", {
                      if "create" in post { html.time(class: "card-date", post.create.display("[year repr:last_two]-[month]-[day]")) }
                      html.h3(class: "card-title", post.title)
                      if "description" in post { html.p(class: "card-desc", post.description) }
                    })
                  })
                }
              })
              
              /*
              html.div(class: "card-grid", picks.map(pair => {
                let (dir, post) = pair
                let url = "/" + dir + "/" // 記事のディレクトリ名をURLにする
                
                html.a(class: "post-card", href: url, {
                  html.div(class: "card-content", {
                    if "create" in post {
                      html.time(class: "card-date", post.create.display("[year repr:last_two]-[month]-[day]"))
                    }
                    html.h3(class: "card-title", post.title)
                    if "description" in post { html.p(class: "card-desc", post.description) }
                  })
                })
              }))
              */
              
              /*
              html.div(class: "card-grid", related_posts.map(post => {
                html.a(class: "post-card", href: post.url, {
                  html.div(class: "card-content", {
                    if "date" in post { html.time(class: "card-date", post.date) }
                    html.h3(class: "card-title", post.title)
                    if "description" in post { html.p(class: "card-desc", post.description) }
                  })
                })
              }))
              */
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
            html.div(class: "sidebar-widget", {
              html.h3(class: "widget-title", "Author")
              html.strong(authors.first())
              html.p(
                style: "font-size: 0.85rem; color: var(--text-muted); margin-top: 0.5em;",
                "Typstが好きです。",
              )
            })
          })
        })
      }) // end .site-container
    })
  })
}

#let embed_youtube(iframe_code) = context {
  // 正規表現で src="..." の中身（URL）を抽出
  // YouTubeのコードはダブルクオート前提でマッチングさせます
  let match = iframe_code.text.match(regex("src=\"([^\"]+)\""))
  
  if match != none {
    let url = match.captures.first()
    if target() == "paged" {
      url
      return
    }
    
    // レスポンシブ用のラッパーdivとiframeを生成
    html.div(class: "video-wrapper", {
      html.elem("iframe", attrs: (
        src: url,
        title: "YouTube video player",
        frameborder: "0",
        allow: "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share",
        referrerpolicy: "strict-origin-when-cross-origin",
        allowfullscreen: "true",
      ))
    })
  } else {
    // マッチしなかった場合はエラーメッセージなどを表示（デバッグ用）
    text(fill: red, "Error: Invalid YouTube embed code")
  }
}

#let embed_misskey_note(note_id, host: "misskey.io") = context {
  import "@preview/suiji:0.5.0": *
  if target() == "paged" {
    note_id
    return
  }
  html.elem("iframe", attrs: (
    src: "https://" + host + "/embed/notes/" + note_id,
    loading: "lazy",
    referrerpolicy: "strict-origin-when-cross-origin",
    style: "border: none; width: 100%; max-width: 500px; height: 280px; color-scheme: light dark;",
    data-misskey-embed-id: "v1_" + shuffle-f(gen-rng-f(2525), range(10000)).at(1).map(it => str(it)).join(""),
  ))
  html.script(defer: true, src: "https://" + host + "embed.js")
}

#let embed_misskey_user_timeline(user_id, host: "misskey.io", max_height: 700) = context {
  import "@preview/suiji:0.5.0": *
  if target() == "paged" {
    user_id
    return
  }
  html.elem("iframe", attrs: (
    src: "https://" + host + "/embed/user-timeline/" + user_id + "?maxHeight=700",
    loading: "lazy",
    referrerpolicy: "strict-origin-when-cross-origin",
    style: "border: none; width: 100%; max-width: 500px; height: 300px; color-scheme: light dark;",
    data-misskey-embed-id: "v1_" + shuffle-f(gen-rng-f(115115), range(15)).at(1).map(it => str(it)).join(""),
  ))
  html.script(defer: true, src: "https://" + host + "embed.js")
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
  set text(font: main-font, size: 12pt, lang: "ja")
  
  if target() == "paged" {
    body
    return
  }
  
  html.html(lang: "ja", {
    html.head({
      html.meta(charset: "utf-8")
      html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
      html.title(title)
      
      // フォント・CSS読み込み (projectと同じ)
      html.link(rel: "preconnect", href: "https://fonts.googleapis.com")
      html.link(rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous")
      html.link(
        rel: "stylesheet",
        href: "https://fonts.googleapis.com/css2?family=Fira+Code:wght@300..700&family=Noto+Serif+JP:wght@400;700&display=swap",
      )
      html.link(rel: "stylesheet", href: "/style.css")
      
      // Meta Tags
      html.elem("meta", attrs: (property: "og:title", content: title))
      if description != "" { html.meta(name: "description", content: description) }
      if og-image != none { html.elem("meta", attrs: (property: "og:image", content: og-image)) }
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
                    html.time(class: "card-date", post.create.display("[year repr:last_two]-[month]-[day]"))
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
            // トップページなので目次(TOC)は表示しない
            
            // 著者プロフィール
            html.div(class: "sidebar-widget", {
              html.h3(class: "widget-title", "執筆者")
              html.strong(authors.first())
              html.p(
                style: "font-size: 0.85rem; color: var(--text-muted); margin-top: 0.5em;",
                [#link("https://bibouroku.minimarimo3.jp")[bibourokuminimarimo3.jp]の管理者],
              )
            })
            
            // ブログについて
            html.div(class: "sidebar-widget", {
              html.h3(class: "widget-title", "本ブログについて")
              html.p(
                style: "font-size: 0.85rem; color: var(--text-muted); margin-top: 0.5em;",
                [本サイトの内容は#link("https://www.wtfpl.net")[WTFPL]で公開されています。サイトに関するご意見は#link("https://forms.gle/hhLGvUeWKyNK1UUz6")[Googleフォーム]までお願いします。],
              )
            })
          })
        })
      }) // end .site-container
    })
  })
}
