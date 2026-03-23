#let common-head(title, description: none, image: none) = {
  html.meta(charset: "utf-8")
  html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
  html.title(title)

  html.link(rel: "preconnect", href: "https://fonts.googleapis.com")
  html.link(rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous")
  html.link(
    rel: "stylesheet",
    href: "https://fonts.googleapis.com/css2?family=Fira+Code:wght@300..700&family=Noto+Serif+JP:wght@400;700&display=swap",
  )

  html.link(rel: "stylesheet", href: "/style.css")
  html.script(src: "/script.js")

  html.elem(
    "script",
    attrs: (
      defer: "",
      src: "https://static.cloudflareinsights.com/beacon.min.js",
      data-cf-beacon: "{\"token\": \"4b32234cfe9741ea8a4437f109f7b029\"}",
    ),
  )

  if description != none and description != "" {
    html.meta(name: "description", content: description)
  }
  html.elem("meta", attrs: (property: "og:title", content: title))
  if image != none {
    html.elem("meta", attrs: (property: "og:image", content: image))
  }
}
