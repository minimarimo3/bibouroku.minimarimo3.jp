#import "template.typ": home
#import "posts.typ": post-data

#show: home.with(
  title: "備忘録",
  description: "",
  authors: ("minimarimo3",),
  
  posts: post-data,
)
