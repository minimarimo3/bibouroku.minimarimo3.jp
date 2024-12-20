#import "../template.typ": configuration, TODO
#show: 本文 => configuration(
  主題: "備忘録を書く", 
  タグ: ("備忘録", "Typst"),
  要約: TODO[
  要約を書く
], 本文)

= 動機

よくわからない。それっぽい理由は浮かぶし、原因になったものはいくつかあると思うんだけど特に決定的ってわけでもない。要するに思いつき。多分宝くじ買うようなもんで単に何か変えたい（変わってほしい？）んだろうな。とりあえず頭に浮かんでるそれっぽい理由を列挙してみるけど、多分関係ないというかどれが欠けても備忘録を書いていた気がする。

  + 賢い人たちは皆いい感じのブログで日々学習したことを発信してるし、そうでなくても知性を感じさせる文章で日常を詩的に？綴っている。これはとってもかっこいい。神だの資本主義だのそういったものに絡めて独り言を言ってるのは楽しそうだしそれを見た人が（俺にはわからない）何かを読み取って深そうな話をしているのはあこがれる？うらやましい？。IQテストパズルみたいなものを楽しんでるのは鼻につくのに何が違うのか。

  + 感情の振り返り。毎日満足してるはずだし、この前見た映画だって面白かった。でもすぐ忘れるし何も心に残っていない。そもそも俺は感覚が鈍いというか、音楽、二次元、ゲーム、どれをとっても受動的かつ一人で完結してしまう節がある。「ゲームやボカロが好き」なんて辞任しても製作者・会社も知らないしそもそもイベントだって一切把握してなかったりする。これはちゃんと文章にして記録をつけていくことで単なる「楽しかった！」から変えられる気がする。本なら覚えているような気がするけどどうだろう？単に背表紙見てるだけだからな気もする。でもそもそも人の名前とかさっぱり覚えられないしこれは感受性？の方をどうにかする必要があるのかもしれない。

  + 見栄っ張りの改善。これは特筆するようなことじゃないと思うけど。公開する理由でもある。いやでも逆にここがいちばんあれなのかも

  + 完全に信用できる情報元の確保。意外と他人は情報源を気にしていないし、発言者の属性で情報を調べもせず嘘だと判断することが割とある。

    例えば、Twitterで昔よく見られたやりとりとして、一方が「人工地震は過去に新聞でも取り上げられている。闇の政府が～」と主張し、それに対して「震度nの地震を起こすにはTNT換算でNトン必要。そのため人工地震は存在しない」と反論するというものがある。

    ここで重要なのは、実際には「人工地震」という言葉は地層調査のための科学技術や専門用語として存在しているという点。
    実際、#link("https://shashinkan.yomiuri.co.jp/photo/result?text=%E4%BA%BA%E5%B7%A5%E5%9C%B0%E9%9C%87&date=date_span&start=&end=")[よみうり報知写真館で検索] すれば「人工地震」が過去の新聞で取り上げられていることは簡単に確認できる。CiNii使えば論文だって見つかる。
    つまり、「人工地震は存在しない」という反論は誤りであり、少なくとも「新聞でも取り上げられている」という主張は正しいのである。

    もし「人工地震」という言葉を一度でも検索したことがある人なら「人工地震は存在するけど、あなたが思っているようなものではないよ」とか、「存在はするけど、それを兵器として使うのは非現実的だよ」といった説明に落ち着くだろう。
    そうであるにも関わらず「人工地震は存在しない」という反論が用いられるのは、自分で調べもせず適当に見つけた反論をそのままコピーペーストしている人間の多さを物語っている訳だ。

= 構築

== 文書作成ツール

+ 出典記載
+ 引用
+ テキスト形式で簡単に書けて読みやすい(変更履歴とかが把握しやすい)
+ Webで公開可能

TeX、Typst、HTML、拡張されたMarkdownの四つで迷ったがレポートで書きなれているTypstで書くことにした。
TeXはインストールが面倒くさく、HTMLは細かすぎ、Markdownは単純すぎてかゆいところに手が届かない感じがある。
拡張されたMarkdownは悪くないと思うんだけど、昔ObsidianとLogseq#footnote([これはOrg ModeとMarkdownが混ざったようなものだが])でSSGを使いサイト公開までやってみたものの何かしっくりこなかったことがあるのでやめた。

== サイトの構成

index.htmlに全PDFへのリンクを張るだけでいいと思う。
余裕があればVSCodeのエクスプローラーみたいなのを置いてクリックしたら文書が右側で展開みたいなのやる。
humans.txtとかogとかも

== 作成

Typstを受け付ける静的サイトジェネレーターとかは現状無い。
ライブラリを入れて連携とかするのは面倒くさいしHTML直書きでいいと思う。
とはいえ備忘録へのリンクをただ並べてくだけってのは味気ないのでまあちょっとカードみたいにして更新したときに自分で見たくなるようなサイトにしたい。
PDFの閲覧にはPDF.jsを使用することにした。

== 公開

修正履歴が見れるようにGitHubのパブリックリポジトリで管理しようと思っているのでGitHub Pagesを使う。
#link("https://docs.github.com/ja/pages/getting-started-with-github-pages/about-github-pages")[]
