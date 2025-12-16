{
	"translatorID": "b54cfab6-ed62-4737-b0e2-7dc4e7348a8e",
	"label": "Hayagriva(Web)",
	"creator": "minimarimo3",
	"target": "yml",
	"minVersion": "5.0",
	"maxVersion": "",
	"priority": 100,
	"inRepository": false,
	"translatorType": 2,
	"browserSupport": "gcsibv",
	"lastUpdated": "2025-12-16 15:30:00"
}

// Zoteroの型をHayagrivaの型にマッピング
const typeMap = {
	"book": "book",
	"bookSection": "chapter",
	"journalArticle": "article",
	"magazineArticle": "article",
	"newspaperArticle": "article",
	"thesis": "thesis",
	"letter": "misc",
	"manuscript": "misc",
	"interview": "misc",
	"film": "misc",
	"artwork": "misc",
	"webpage": "web",
	"report": "report",
	"conferencePaper": "proceedings",
	"blogPost": "web"
};

// 文字列のエスケープ処理（YAML用）
function escapeString(str) {
	if (!str) return "";
	return '"' + str.replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '"';
}

// キー用のクリーンアップ（英数字のみ）
function cleanAuthorPart(str) {
	if (!str) return "";
	return str.toLowerCase().replace(/[^a-z0-9]/g, "");
}

// タイトル用のクリーンアップ（スネークケース化）
function cleanTitlePart(str) {
	if (!str) return "";
	// 小文字化 -> 英数字とスペース以外削除 -> スペースをアンダーバーに置換 -> 重複アンダーバー削除
	var s = str.toLowerCase()
		.replace(/[^a-z0-9\s]/g, "")
		.trim()
		.replace(/\s+/g, "_");
	
	// 長すぎる場合はカット（目安30文字）
	if (s.length > 30) {
		s = s.substring(0, 30);
		// 末尾がアンダーバーなら削除
		s = s.replace(/_$/, "");
	}
	return s;
}

function doExport() {
	var item;
	while (item = Zotero.nextItem()) {
		// --- 引用キー生成ロジック ---
		var citationKey = item.citationKey;
		
		// 優先的に使用する「サイト名/コンテナ名」を取得
		var containerTitle = item.publicationTitle || item.publisher || item.websiteTitle || item.seriesTitle || item.blogTitle;
		
		if (!citationKey) {
			// 1. Author Part (著者 または サイト名)
			var authorPart = "";
			if (item.creators && item.creators.length > 0) {
				var c = item.creators[0];
				authorPart = c.lastName || c.firstName || ""; 
			} else if (containerTitle) {
				authorPart = containerTitle;
			} else {
				authorPart = "unknown";
			}
			authorPart = cleanAuthorPart(authorPart);
			if (authorPart.length > 15) authorPart = authorPart.substring(0, 15);

			// 2. Year Part (作成日 -> アクセス日 -> nd)
			var yearPart = "nd";
			var dateSource = item.date;
			
			// 日付がない場合、アクセス日をフォールバックとして使用
			if (!dateSource && item.accessDate) {
				dateSource = item.accessDate;
			}
			
			if (dateSource) {
				var dateMatch = dateSource.match(/\d{4}/);
				if (dateMatch) yearPart = dateMatch[0];
			}

			// 3. Title Part (スネークケース)
			var titlePart = "";
			if (item.title) {
				var cleanTitle = cleanTitlePart(item.title);
				// キーが見やすいようにアンダーバーでつなぐ
				if (cleanTitle) {
					titlePart = "_" + cleanTitle;
				}
			}

			// 結合 (例: github2025_html_export_issue)
			citationKey = authorPart + yearPart + titlePart;
		}

		// --- 出力処理 ---
		
		Zotero.write(citationKey + ":\n");

		var type = typeMap[item.itemType] || "misc";
		Zotero.write("  type: " + type + "\n");

		if (item.title) {
			Zotero.write("  title: " + escapeString(item.title) + "\n");
		}

		// 著者
		var authors = [];
		var editors = [];
		if (item.creators) {
			for (var i in item.creators) {
				var creator = item.creators[i];
				var nameStr = "";
				if (creator.lastName && creator.firstName) {
					nameStr = creator.lastName + ", " + creator.firstName;
				} else if (creator.lastName) {
					nameStr = creator.lastName;
				} else if (creator.firstName) {
					nameStr = creator.firstName;
				}
				if (nameStr) {
					if (creator.creatorType === "editor" || creator.creatorType === "seriesEditor") {
						editors.push(nameStr);
					} else {
						authors.push(nameStr);
					}
				}
			}
		}

		if (authors.length > 0) {
			Zotero.write("  author:\n");
			for (var i = 0; i < authors.length; i++) {
				Zotero.write("    - " + escapeString(authors[i]) + "\n");
			}
		}
		if (editors.length > 0) {
			Zotero.write("  editor:\n");
			for (var i = 0; i < editors.length; i++) {
				Zotero.write("    - " + escapeString(editors[i]) + "\n");
			}
		}

		if (item.date) {
			Zotero.write("  date: " + escapeString(item.date) + "\n");
		}
		
		if (item.accessDate) {
			Zotero.write("  access-date: " + escapeString(item.accessDate) + "\n");
		}

		if (item.url) Zotero.write("  url: " + escapeString(item.url) + "\n");
		if (item.DOI) Zotero.write("  doi: " + escapeString(item.DOI) + "\n");
		if (item.pages) Zotero.write("  page-range: " + escapeString(item.pages) + "\n");
		
		// サイト名・出版社
		if (containerTitle) {
			if (type === "web") {
				Zotero.write("  organization: " + escapeString(containerTitle) + "\n");
			} else {
				Zotero.write("  publisher: " + escapeString(containerTitle) + "\n");
			}
		}
		
		if (item.abstractNote) {
			Zotero.write("  abstract: " + escapeString(item.abstractNote) + "\n");
		}
		
		if (item.volume) Zotero.write("  volume: " + escapeString(item.volume) + "\n");
		if (item.issue) Zotero.write("  issue: " + escapeString(item.issue) + "\n");

		Zotero.write("\n");
	}
}