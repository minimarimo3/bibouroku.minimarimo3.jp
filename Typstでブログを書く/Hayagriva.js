{
	"translatorID": "6410383f-9336-4c7d-a019-d38d2ac08865",
	"label": "Hayagriva",
	"creator": "minimarimo3",
	"target": "yaml",
	"minVersion": "5.0",
	"maxVersion": "",
	"priority": 100,
	"inRepository": false,
	"translatorType": 2,
	"lastUpdated": "2025-12-19 18:00:00"
}

// --- Helper Functions ---

// YAML String Escape
function escapeYamlString(str) {
    if (!str && str !== 0) return "";
    str = "" + str;

    // If it contains special chars or is explicitly empty, quote it.
    // : { } [ ] , & * # ? | - < > = ! % @ \ "
    if (/[:{}\[\],&*#?|\-<>!=%@\\"]/.test(str) || str.trim() === "") {
        return '"' + str.replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '"';
    }
    return str;
}

// Remove HTML tags from string
function stripHtml(str) {
    if (!str) return "";
    return str.replace(/<[^>]*>/g, "");
}

// Slugify using Unicode Property Escapes (Whitelist approach)
function slugify(str) {
    if (!str) return "";

    // 1. Remove HTML tags
    str = stripHtml(str);

    // 2. Replace ANY character that is NOT a Letter, Number, Hyphen, or Underscore
    // \p{L} = Any Unicode Letter (English, Kanji, Hiragana, etc.)
    // \p{N} = Any Unicode Number
    // \-    = Hyphen-minus
    // _     = Underscore
    // 'u' flag is required for Unicode property escapes
    str = str.replace(/[^\p{L}\p{N}\-_]+/gu, "_");

    // 3. Remove leading/trailing underscores
    str = str.replace(/^_+|_+$/g, "");

    return str;
}

// 40-char limited ID Generation
// Rule: (Organization/Author)_(Year_)(Title)
function generateCitationKey(item) {
    // 1. Organization / Author Part
    let org = "";
    if (item.publisher) org = item.publisher;
    else if (item.institution) org = item.institution;
    else if (item.organization) org = item.organization;
    else if (item.websiteTitle) org = item.websiteTitle;
    else if (item.university) org = item.university;
    else if (item.label) org = item.label;

    // Fallback to first creator if no organization found
    if (!org && item.creators && item.creators.length > 0) {
        let c = item.creators[0];
        org = c.lastName || c.name;
    }

    if (!org && item.url) {
        // Extract domain from URL
        try {
            let urlObj = new URL(item.url);
            org = urlObj.hostname.replace(/^www\./, "");
        } catch (e) {
            // Invalid URL, do nothing
        }
    }

    if (!org) org = "noorg";

    org = slugify(org);

    // 2. Date Part
    /*
    let datePart = "";
    let dateObj = Zotero.Utilities.strToDate(item.date);
    if (dateObj && dateObj.year) {
        datePart = dateObj.year.toString() + "_";
    }
    */

    // 3. Title Part
    let title = slugify(item.title || "notitle");

    // Combine
    // let fullKey = `${org}_${datePart}${title}`;
    let fullKey = `${org}_${title}`;

    // 40 char limit
    if (fullKey.length > 40) {
        fullKey = fullKey.substring(0, 40);
        fullKey = fullKey.replace(/_+$/, "");
    }

    return fullKey;
}

// Role Mapping
function mapRole(zoteroType) {
    const map = {
        "translator": "translator",
        "contributor": "collaborator",
        "editor": "editor",
        "seriesEditor": "editor",
        "interviewee": "collaborator",
        "interviewer": "collaborator",
        "director": "director",
        "scriptwriter": "writer",
        "producer": "producer",
        "castMember": "cast-member",
        "sponsor": "organizer",
        "counsel": "collaborator",
        "inventor": "holder",
        "artist": "illustrator",
        "performer": "cast-member",
        "composer": "composer",
        "wordsBy": "writer",
        "cartographer": "illustrator",
        "programmer": "writer",
        "podcaster": "executive-producer",
        "presenter": "cast-member"
    };
    return map[zoteroType] || "collaborator";
}

// Item Type Mapping
function getHayagrivaType(itemType) {
    const map = {
        book: "book",
        bookSection: "chapter",
        journalArticle: "article",
        magazineArticle: "article",
        newspaperArticle: "article",
        thesis: "thesis",
        letter: "misc",
        manuscript: "manuscript",
        interview: "misc",
        film: "video",
        artwork: "artwork",
        webpage: "web",
        conferencePaper: "article", // Parent: proceedings
        report: "report",
        bill: "legislation",
        case: "case",
        hearing: "misc",
        patent: "patent",
        statute: "legislation",
        email: "misc",
        map: "misc",
        blogPost: "article", // Parent: blog
        instantMessage: "misc",
        forumPost: "thread",
        audioRecording: "audio",
        presentation: "misc",
        videoRecording: "video",
        tvBroadcast: "video",
        radioBroadcast: "audio",
        podcast: "audio",
        computerProgram: "repository",
        document: "misc",
        encyclopediaArticle: "entry",
        dictionaryEntry: "entry"
    };
    return map[itemType] || "misc";
}

// Build Parent Metadata
function buildParent(item, childType) {
    let parent = {};
    let hasParent = false;

    // 1. Periodical
    if (["journalArticle", "magazineArticle", "newspaperArticle"].includes(item.itemType)) {
        parent.type = "periodical";
        if (item.itemType === "newspaperArticle") parent.type = "newspaper";

        if (item.publicationTitle) parent.title = item.publicationTitle;
        if (item.volume) parent.volume = item.volume;
        if (item.issue) parent.issue = item.issue;
        if (item.series) parent.series = item.series;

        hasParent = !!item.publicationTitle;
    }
    // 2. Book Section
    else if (item.itemType === "bookSection") {
        parent.type = "book";
        if (item.publicationTitle) parent.title = item.publicationTitle;
        if (item.series) parent["serial-number"] = { serial: item.series };
        if (item.volume) parent.volume = item.volume;
        if (item.numberOfVolumes) parent["volume-total"] = item.numberOfVolumes;
        if (item.edition) parent.edition = item.edition;
        if (item.publisher) parent.publisher = item.publisher;
        if (item.place) parent.location = item.place;

        hasParent = !!item.publicationTitle;
    }
    // 3. Conference Paper
    else if (item.itemType === "conferencePaper") {
        parent.type = "proceedings";
        if (item.publicationTitle) {
            parent.title = item.publicationTitle;
        } else if (item.conferenceName) {
            parent.title = item.conferenceName;
            parent.type = "conference";
        }

        if (item.publisher) parent.publisher = item.publisher;
        if (item.place) parent.location = item.place;
        if (item.volume) parent.volume = item.volume;

        hasParent = !!parent.title;
    }
    // 4. Blog Post
    else if (item.itemType === "blogPost") {
        parent.type = "blog";
        if (item.blogTitle || item.publicationTitle) {
            parent.title = item.blogTitle || item.publicationTitle;
            hasParent = true;
        }
        if (item.websiteType) parent.genre = item.websiteType;
    }
    // 5. Website
    else if (item.itemType === "webpage") {
        if (item.websiteTitle || item.publicationTitle) {
            parent.type = "web";
            parent.title = item.websiteTitle || item.publicationTitle;
            hasParent = true;
        }
    }

    return hasParent ? parent : null;
}

// Main Export
function doExport() {
    var item;
    while (item = Zotero.nextItem()) {
        if (item.itemType === "note" || item.itemType === "attachment") continue;

        var key = generateCitationKey(item);
        var hayagrivaType = getHayagrivaType(item.itemType);

        Zotero.write(key + ":\n");
        Zotero.write("  type: " + hayagrivaType + "\n");

        if (item.title) {
            Zotero.write("  title: " + escapeYamlString(stripHtml(item.title)) + "\n");
        }

        if (item.date) {
            var isoDate = Zotero.Utilities.strToISO(item.date);
            if (isoDate) {
                Zotero.write("  date: " + isoDate + "\n");
            } else {
                Zotero.write("  date: " + escapeYamlString(item.date) + "\n");
            }
        }

        // Parent Construction
        var parentObj = buildParent(item, hayagrivaType);

        // Creators
        var authors = [];
        var editors = [];
        var parentEditors = [];
        var affiliated = [];

        if (item.creators) {
            for (let creator of item.creators) {
                let nameStr = "";
                if (creator.lastName) {
                    nameStr = creator.lastName;
                    if (creator.firstName && creator.fieldMode !== 1) {
                        nameStr += ", " + creator.firstName;
                    }
                } else if (creator.name) {
                    nameStr = creator.name;
                }

                if (!nameStr) continue;
                nameStr = escapeYamlString(nameStr);

                if (creator.creatorType === "author") {
                    authors.push(nameStr);
                } else if (creator.creatorType === "editor") {
                    if (parentObj && ["chapter", "article", "entry"].includes(hayagrivaType)) {
                        parentEditors.push(nameStr);
                    } else {
                        editors.push(nameStr);
                    }
                } else if (creator.creatorType === "bookAuthor") {
                    if (!parentObj) parentObj = { type: "book" };
                    if (!parentObj.author) parentObj.author = [];
                    parentObj.author.push(nameStr);
                } else if (creator.creatorType === "seriesEditor") {
                    if (!parentObj) parentObj = { type: "anthology" };
                    if (!parentObj.editor) parentObj.editor = [];
                    parentObj.editor.push(nameStr);
                } else {
                    let role = mapRole(creator.creatorType);
                    let found = false;
                    for (let aff of affiliated) {
                        if (aff.role === role) {
                            aff.names.push(nameStr);
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        affiliated.push({ role: role, names: [nameStr] });
                    }
                }
            }
        }

        if (authors.length > 0) {
            Zotero.write("  author:\n");
            for (let a of authors) Zotero.write("    - " + a + "\n");
        }

        if (editors.length > 0) {
            Zotero.write("  editor:\n");
            for (let e of editors) Zotero.write("    - " + e + "\n");
        }

        if (affiliated.length > 0) {
            Zotero.write("  affiliated:\n");
            for (let aff of affiliated) {
                Zotero.write("    - role: " + aff.role + "\n");
                if (aff.names.length === 1) {
                    Zotero.write("      names: " + aff.names[0] + "\n");
                } else {
                    Zotero.write("      names:\n");
                    for (let n of aff.names) Zotero.write("        - " + n + "\n");
                }
            }
        }

        // Serial Numbers
        let serials = {};
        if (item.DOI) serials.doi = item.DOI;
        if (item.ISBN) serials.isbn = item.ISBN;
        if (item.ISSN) serials.issn = item.ISSN;
        if (item.PMID) serials.pmid = item.PMID;
        if (item.PMCID) serials.pmcid = item.PMCID;

        if (item.extra) {
            let lines = item.extra.split("\n");
            for (let line of lines) {
                let m = line.match(/^(arXiv|LCCN|MR|Zbl):\s*(.+)$/i);
                if (m) serials[m[1].toLowerCase()] = m[2].trim();
            }
        }

        if (Object.keys(serials).length > 0) {
            Zotero.write("  serial-number:\n");
            for (let key in serials) {
                Zotero.write("    " + key + ": " + escapeYamlString(serials[key]) + "\n");
            }
        }

        // Other fields
        if (item.url) {
            if (item.accessDate) {
                Zotero.write("  url:\n");
                Zotero.write("    value: " + escapeYamlString(item.url) + "\n");
                Zotero.write("    date: " + Zotero.Utilities.strToISO(item.accessDate) + "\n");
            } else {
                Zotero.write("  url: " + escapeYamlString(item.url) + "\n");
            }
        }

        if (item.abstractNote) {
            Zotero.write("  abstract: " + escapeYamlString(stripHtml(item.abstractNote)) + "\n");
        }

        if (item.language) {
            Zotero.write("  language: " + escapeYamlString(item.language) + "\n");
        }

        if (item.pages) {
            Zotero.write("  page-range: " + escapeYamlString(item.pages) + "\n");
        }
        if (item.numPages) {
            Zotero.write("  page-total: " + item.numPages + "\n");
        }

        if (item.archive) {
            Zotero.write("  archive: " + escapeYamlString(item.archive) + "\n");
            if (item.archiveLocation) {
                Zotero.write("  archive-location: " + escapeYamlString(item.archiveLocation) + "\n");
            }
            if (item.callNumber) {
                Zotero.write("  call-number: " + escapeYamlString(item.callNumber) + "\n");
            }
        }

        if (item.runningTime) {
            Zotero.write("  runtime: " + escapeYamlString(item.runningTime) + "\n");
        }

        // Merge Parent Editors
        if (parentEditors.length > 0) {
            if (!parentObj) parentObj = { type: "misc" };
            if (!parentObj.editor) parentObj.editor = [];
            parentObj.editor = parentObj.editor.concat(parentEditors);
        }

        // Output Parent
        if (parentObj) {
            Zotero.write("  parent:\n");
            if (parentObj.type) Zotero.write("    type: " + parentObj.type + "\n");
            if (parentObj.title) Zotero.write("    title: " + escapeYamlString(stripHtml(parentObj.title)) + "\n");
            if (parentObj.volume) Zotero.write("    volume: " + escapeYamlString(parentObj.volume) + "\n");
            if (parentObj.issue) Zotero.write("    issue: " + escapeYamlString(parentObj.issue) + "\n");
            if (parentObj["volume-total"]) Zotero.write("    volume-total: " + parentObj["volume-total"] + "\n");
            if (parentObj.publisher) Zotero.write("    publisher: " + escapeYamlString(parentObj.publisher) + "\n");
            if (parentObj.location) Zotero.write("    location: " + escapeYamlString(parentObj.location) + "\n");
            if (parentObj.date) Zotero.write("    date: " + escapeYamlString(parentObj.date) + "\n");
            if (parentObj.genre) Zotero.write("    genre: " + escapeYamlString(parentObj.genre) + "\n");
            if (parentObj["serial-number"]) {
                if (typeof parentObj["serial-number"] === "object") {
                    Zotero.write("    serial-number:\n");
                    for (let k in parentObj["serial-number"]) {
                        Zotero.write("      " + k + ": " + escapeYamlString(parentObj["serial-number"][k]) + "\n");
                    }
                } else {
                    Zotero.write("    serial-number: " + escapeYamlString(parentObj["serial-number"]) + "\n");
                }
            }

            if (parentObj.author && parentObj.author.length > 0) {
                Zotero.write("    author:\n");
                for (let pa of parentObj.author) Zotero.write("      - " + pa + "\n");
            }

            if (parentObj.editor && parentObj.editor.length > 0) {
                Zotero.write("    editor:\n");
                for (let pe of parentObj.editor) Zotero.write("      - " + pe + "\n");
            }
        }

        Zotero.write("\n");
    }
}