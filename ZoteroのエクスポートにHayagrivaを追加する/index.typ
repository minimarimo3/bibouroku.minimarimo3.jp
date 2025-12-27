#import "../template.typ": project, note, note, tip, important, warning, caution, env
#import "../posts.typ": post-data
// #let meta = post-data.at("ZoteroのエクスポートにHayagrivaを追加する")
// #show: project.with(..meta)

#env(
  ("Typst", "0.14", "TYPST_FEATURES=html"),
  ("Zotero", "7.0.30")
)

= はじめに

TypstのbibはBibLaTeXに加えてHayagrivaという形式をサポートしています。
HayagrivaというのはTypstが開発している文献管理用の形式で、YAMLで表現されます。

論文等を書くならBibLaTeXの方が色々便利なのでしょうが、私のようにMarkdownより表現力のあるマークアップ言語としてTypstを使用している人からするとHayagrivaの方が色々扱いやすいため好ましいです。

しかし私が使用している文献管理サービスであるZoteroはHayagrivaでのエクスポートをサポートしていません。
#footnote[
  Hayagrivaの直接エクスポートをサポートしているOSSの文献管理サービスとしては#link("https://www.jabref.org")[JabRef]というものがあり、ソフトそのものの使用感は悪くないです。
  しかし、JabRef Browser Extension(JabRef版Zotero Connector)がManifest V2でアプデの希望もなさそうな感じなので使用は見送りました。TODO: ref
]
hayagriva cliを使用して機械的に変換することも考えましたが、もともとWebサイトをZoteroで管理しているとbibでエクスポートしたときにキーが`noauthor`と`nodate`だらけになることに不満を覚えていたこともあり、拡張機能を作ることにしました。

= 実装

実装はZoteroのExport translatorを追加する形で行います。
Translatorについて詳しいことは#link("https://www.zotero.org/support/dev/translators")[公式サイトの解説]を参照して下さい。

作業は基本的に#link("https://www.zotero.org/support/kb/item_types_and_fields")[Zoteroのメタデータ]を#link("https://github.com/typst/hayagriva/blob/main/docs/file-format.md#reference")[Hayagrivaのメタデータ]に翻訳していくものになります。
