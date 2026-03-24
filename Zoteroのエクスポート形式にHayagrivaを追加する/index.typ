#import "../template.typ": article, d, note, tip, important, warning, caution, env

#let meta = (
  slug: "Zoteroのエクスポート形式にHayagrivaを追加する",
  title: "Zoteroのエクスポート形式にHayagrivaを追加する",
  create: d(2026, 3, 14),
  update: d(2026, 3, 24),
  description: "Typstで文献リストとして使用可能なHayagriva形式（YAML）ですがZoteroで直接エクスポートできないため、いったんbibファイルでエクスポートしてからhayagriva cliで変換する必要があります。地味に手間なのでZoteroから直接Hayagrivaでのエクスポートを可能にする拡張機能を作成しました。",
)

#metadata(meta) <post-meta>
#show: article.with(..meta)

#env(
  ("Typst", "0.14.2", "TYPST_FEATURES=html"),
  ("Zotero", "8.0.4")
)

= はじめに

TypstのbibはBibLaTeXに加えてHayagrivaという形式をサポートしています。
HayagrivaというのはTypstが開発している文献管理用の形式で、YAMLで表現されます。

論文等を書くならBibLaTeXの方が色々便利なのでしょうが、私のようにMarkdownより表現力のあるマークアップ言語としてTypstを使用している人からするとHayagriva(というかYAML)の方が色々扱いやすいため好ましいです。

しかし私が使用している文献管理サービスであるZoteroはHayagrivaでのエクスポートをサポートしていません。
#footnote[
  Hayagrivaの直接エクスポートをサポートしているOSSの文献管理サービスとしては#link("https://www.jabref.org")[JabRef]というものがあり、ソフトそのものの使用感は悪くないです。
  しかし、#link("https://github.com/JabRef/JabRef-Browser-Extension")[JabRef Browser Extension(JabRef版Zotero Connector)]がManifest V2でアプデの希望もなさそうな感じなので使用は見送りました。（今ならAIにお任せすればできそうではありますね）
]
hayagriva cliを使用して機械的に変換することも考えましたが、もともとWebサイトをZoteroで管理しているとbibでエクスポートしたときにキーが`noauthor`と`nodate`だらけになることに不満を覚えていたこともあり、拡張機能を作りました。

= 使い方

#link("https://gist.github.com/minimarimo3/c341778865e0561af33feb2e8090d795")[Gistのコード]をHayagriva.jsという名前で保存し、#[@translators-path]に移動させてください。
Zoteroの再起動後、「コレクションをエクスポート」→「フォーマット」でHayagrivaを選択可能になります(#[@zotero-select])。

#figure(
  caption: [Hayagriva.jsを配置する場所],
  table(
    columns: 2,
    table.header("OS", "Path"),
    "Windows", `C:\Users\{Name}\Zotero\translators/`.text,
    "macOS", "/Users/{Name}/Zotero/translators/",
  )
) <translators-path>

#figure(
  caption: [Zoteroのエクスポート形式の選択欄でHayagrivaが選択されている],
  image("image.png", alt: "Zoteroのエクスポート形式の選択欄でHayagrivaが選択されている")
) <zotero-select>

= 実例

== 変換対象のbib

```bib
@article{noauthor_pdf_2024,
	title = {({PDF}) Eyes Alive},
	url = {https://www.researchgate.net/publication/2534686_Eyes_Alive},
	doi = {10.1145/566570.566629},
	abstract = {{PDF} {\textbar} For an animated human face model to appear natural it should produce eye movements consistent with human ocular behavior. During face-to-face... {\textbar} Find, read and cite all the research you need on {ResearchGate}},
	journaltitle = {{ResearchGate}},
	urldate = {2025-01-23},
	date = {2024-10-22},
	langid = {english},
	file = {PDF:C\:\\Users\\minimarimo3\\Zotero\\storage\\57LKGKD4\\2024 - (PDF) Eyes Alive.pdf:application/pdf;Snapshot:C\:\\Users\\minimarimo3\\Zotero\\storage\\NGTZGVG4\\2534686_Eyes_Alive.html:text/html},
}

@article{venture_recognizing_2014,
	title = {Recognizing Emotions Conveyed by Human Gait},
	volume = {6},
	issn = {1875-4805},
	url = {https://doi.org/10.1007/s12369-014-0243-1},
	doi = {10.1007/s12369-014-0243-1},
	abstract = {Humans convey emotions through different ways. Gait is one of them. Here we propose to use gait data to highlight features that characterize emotions. Gait analysis study usually focuses on stance phase, frequency, footstep length. Here the study is based on the joint angles obtained from inverse kinematics computation from the 3D motion-capture data using a combination of degrees of freedom ({DOF}) out of a 34DOF human body model obtained from inverse kinematics of markers 3D position. The candidates are four professional actors, and five emotional states are simulated: Neutral, Joy, Anger, Sadness, and Fear. The paper presents first a psychological approach which results are used to propose numerical approaches. The first study provides psychological results on motion perception and the possibility of emotion recognition from gait by 32 observers. Then, the motion data is studied using a feature vector approach to verify the numerical identifiability of the emotions. Finally each motion is tested against a database of reference motions to identify the conveyed emotion. Using the first and second study results, we utilize a 6DOF model then a 12DOF model. The experimental results show that by using the gait characteristics it is possible to characterize each emotion with good accuracy for intra-subject data-base. For inter-subject database results show that recognition is more prone to error, suggesting strong inter-personal differences in emotional features.},
	pages = {621--632},
	number = {4},
	journaltitle = {International Journal of Social Robotics},
	shortjournal = {Int J of Soc Robotics},
	author = {Venture, Gentiane and Kadone, Hideki and Zhang, Tianxiang and Grèzes, Julie and Berthoz, Alain and Hicheur, Halim},
	urldate = {2025-01-23},
	date = {2014-11-01},
	langid = {english},
	keywords = {Emotion, Gait, Recognition},
	file = {Full Text PDF:C\:\\Users\\minimarimo3\\Zotero\\storage\\YVXRMIIP\\Venture et al. - 2014 - Recognizing Emotions Conveyed by Human Gait.pdf:application/pdf},
}

@online{noauthor__nodate,
	title = {教育活動},
	url = {https://square.umin.ac.jp/haru-labo/kine/kine_main.html},
	urldate = {2025-01-23},
	file = {教育活動:C\:\\Users\\minimarimo3\\Zotero\\storage\\5KQF7886\\kine_main.html:text/html},
}
```

== 当拡張機能でエクスポートしたHayagriva

```yaml
researchgate_net_2024_pdf_eyes_alive:
  type: article
  title: "(PDF) Eyes Alive"
  date: 2024-10-22
  serial-number:
    doi: "10.1145/566570.566629"
  language: en
  url:
    value: https://www.researchgate.net/publication/2534686_Eyes_Alive
    date: 2025-01-23
  abstract: "PDF | For an animated human face model to appear natural it should produce eye movements consistent with human ocular behavior. During face-to-face... | Find, read and cite all the research you need on ResearchGate"
  note: "Catalog: www.researchgate.net"
  parent:
    type: periodical
    title: "ResearchGate"

venture_2014_recognizing_emotions_convey:
  type: article
  title: "Recognizing Emotions Conveyed by Human Gait"
  author:
    - "Venture, Gentiane"
    - "Kadone, Hideki"
    - "Zhang, Tianxiang"
    - "Grèzes, Julie"
    - "Berthoz, Alain"
    - "Hicheur, Halim"
  date: 2014-11-01
  serial-number:
    doi: "10.1007/s12369-014-0243-1"
    issn: "1875-4805"
  language: en
  page-range: 621-632
  url:
    value: https://doi.org/10.1007/s12369-014-0243-1
    date: 2025-01-23
  abstract: "Humans convey emotions through different ways. Gait is one of them. Here we propose to use gait data to highlight features that characterize emotions. Gait analysis study usually focuses on stance phase, frequency, footstep length. Here the study is based on the joint angles obtained from inverse kinematics computation from the 3D motion-capture data using a combination of degrees of freedom (DOF) out of a 34DOF human body model obtained from inverse kinematics of markers 3D position. The candidates are four professional actors, and five emotional states are simulated: Neutral, Joy, Anger, Sadness, and Fear. The paper presents first a psychological approach which results are used to propose numerical approaches. The first study provides psychological results on motion perception and the possibility of emotion recognition from gait by 32 observers. Then, the motion data is studied using a feature vector approach to verify the numerical identifiability of the emotions. Finally each motion is tested against a database of reference motions to identify the conveyed emotion. Using the first and second study results, we utilize a 6DOF model then a 12DOF model. The experimental results show that by using the gait characteristics it is possible to characterize each emotion with good accuracy for intra-subject data-base. For inter-subject database results show that recognition is more prone to error, suggesting strong inter-personal differences in emotional features."
  note: "Catalog: Springer Link"
  parent:
    type: periodical
    title: "International Journal of Social Robotics"
    volume: 6
    issue: 4

square_umin_ac_jp_教育活動:
  type: web
  title: "教育活動"
  url:
    value: https://square.umin.ac.jp/haru-labo/kine/kine_main.html
    date: 2025-01-23
  parent:
    type: web
```

== Hayagriva cliで変換したHayagriva

```yaml
noauthor_pdf_2024:
  type: article
  title: ({PDF}) Eyes Alive
  date: 2024-10-22
  url:
    value: https://www.researchgate.net/publication/2534686_Eyes_Alive
    date: 2025-01-23
  serial-number:
    doi: 10.1145/566570.566629
  language: en-US
  abstract: '{PDF} {|} For an animated human face model to appear natural it should produce eye movements consistent with human ocular behavior. During face-to-face... {|} Find, read and cite all the research you need on {ResearchGate}'
  parent:
    type: periodical
    title: '{ResearchGate}'
venture_recognizing_2014:
  type: article
  title: Recognizing Emotions Conveyed by Human Gait
  author:
  - Venture, Gentiane
  - Kadone, Hideki
  - Zhang, Tianxiang
  - Grèzes, Julie
  - Berthoz, Alain
  - Hicheur, Halim
  date: 2014-11-01
  page-range: 621-632
  url:
    value: https://doi.org/10.1007/s12369-014-0243-1
    date: 2025-01-23
  serial-number:
    doi: 10.1007/s12369-014-0243-1
    issn: 1875-4805
  language: en-US
  abstract: 'Humans convey emotions through different ways. Gait is one of them. Here we propose to use gait data to highlight features that characterize emotions. Gait analysis study usually focuses on stance phase, frequency, footstep length. Here the study is based on the joint angles obtained from inverse kinematics computation from the 3D motion-capture data using a combination of degrees of freedom ({DOF}) out of a 34DOF human body model obtained from inverse kinematics of markers 3D position. The candidates are four professional actors, and five emotional states are simulated: Neutral, Joy, Anger, Sadness, and Fear. The paper presents first a psychological approach which results are used to propose numerical approaches. The first study provides psychological results on motion perception and the possibility of emotion recognition from gait by 32 observers. Then, the motion data is studied using a feature vector approach to verify the numerical identifiability of the emotions. Finally each motion is tested against a database of reference motions to identify the conveyed emotion. Using the first and second study results, we utilize a 6DOF model then a 12DOF model. The experimental results show that by using the gait characteristics it is possible to characterize each emotion with good accuracy for intra-subject data-base. For inter-subject database results show that recognition is more prone to error, suggesting strong inter-personal differences in emotional features.'
  parent:
    type: periodical
    title: International Journal of Social Robotics
    issue: 4
    volume: 6
noauthor__nodate:
  type: web
  title: 教育活動
  url:
    value: https://square.umin.ac.jp/haru-labo/kine/kine_main.html
    date: 2025-01-23
```

= 実装

実装はZoteroのExport translatorを追加する形で行います。
Translatorについて詳しいことは#link("https://www.zotero.org/support/dev/translators")[公式サイトの解説]を参照して下さい。

作業は基本的に#link("https://www.zotero.org/support/kb/item_types_and_fields")[Zoteroのメタデータ]を#link("https://github.com/typst/hayagriva/blob/main/docs/file-format.md#reference")[Hayagrivaのメタデータ]に翻訳していくものになります。
