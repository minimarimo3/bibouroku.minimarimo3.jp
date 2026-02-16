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