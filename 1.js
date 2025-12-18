var zotero2hayagrivaTypeMap = {
	book: "book",
	bookSection: "chapter",
	journalArticle: "article",
	magazineArticle: "article",
	newspaperArticle: "article",
	thesis: "thesis",
	letter: "misc", // Hayagrivaには手紙専用の型がないため
	manuscript: "manuscript",
	interview: "misc", // 録音・録画ならaudio/videoだが、テキストならmisc
	film: "video",
	artwork: "artwork",
	webpage: "web",
	conferencePaper: "article", // Proceedings内の論文はarticleとする仕様のため
	report: "report",
	bill: "legislation",
	case: "case",
	hearing: "misc", // 聴聞会
	patent: "patent",
	statute: "legislation",
	email: "misc",
	map: "misc",
	blogPost: "article", // webではなくarticle (parent: blog) とするのが推奨されているため
	instantMessage: "misc",
	forumPost: "post", // マイクロブログ等の投稿として扱う
	audioRecording: "audio",
	presentation: "misc", // performanceは芸術的実演を指すため、プレゼンはmisc
	videoRecording: "video",
	tvBroadcast: "video",
	radioBroadcast: "audio",
	podcast: "audio",
	computerProgram: "repository", // ソフトウェアそのものやコード置き場
	document: "misc",
	encyclopediaArticle: "entry",
	dictionaryEntry: "entry"
};