import os
import shutil
import datetime

from pypdf import PdfReader


HTML_TEMPLATE_1 = r"""
<!doctype html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ﾐﾆﾏﾘﾓの備忘録</title>
    <script src="header_footer_loader.js"></script>
    <link rel="stylesheet" href="base.css">
</head>
<body>
    <header></header>

    <main>
        <div class="cards">
"""

HTML_TEMPLATE_2 = r"""
        </div> <!-- cards -->
    </main>

    <footer></footer>

</body>
</html>
"""

# PDFファイルを格納するためのフォルダを作成
output_dir = "public/pdf_files"
os.makedirs(output_dir, exist_ok=True)

# PDFファイル一覧を取得（ファイルパスと更新日時のタプルのリスト）
pdf_files = []
for root, directory, filenames in os.walk("."):  # 現在のディレクトリを再帰的に探索
    if "dist" not in directory:
        continue
    print(root)

    # README(概要)があるなら読み込む
    about = None
    if os.path.isfile((readme_path := os.path.join(root, "README.md"))):
        with open(readme_path, "r", encoding="utf-8") as f:
            about = f.read()

    # book.pdfから更新日時を取得
    for filename in filenames:
        if not filename == "book.pdf":
            continue
        full_path = os.path.join(root, filename)
        # 更新日時を取得(YYYY-MM-DD)
        last_modified = datetime.datetime.fromtimestamp(os.path.getmtime(full_path)).strftime("%Y-%m-%d")

        # あるならPDFファイルのメタデータから更新日時を取得したい
        pdf_metadata = PdfReader(full_path).metadata
        if pdf_metadata and "/ModDate" in pdf_metadata:
            mod_date = pdf_metadata["/ModDate"]
            # PDFの日付形式は`D:YYYYMMDDHHMMSS`
            last_modified = f"{mod_date[2:6]}-{mod_date[6:8]}-{mod_date[8:10]}"

        pdf_files.append((root, last_modified, about))

# 更新日時で昇順にソート
pdf_files.sort(key=lambda x: x[1])

# PDFファイルをコピーし、HTMLリンクを作成
links = []
for root, last_modified, about in pdf_files:
    title = os.path.basename(root)

    links.append(f"""\
            <a href="{title}">
                <article class="card">
                    <h3>{title}</h3>
                    <p>最終更新: <time datetime="{last_modified}">{last_modified}</time></p><br>
                    <p>概要{f": {about.replace("\n\n", "<br>")}" if about else "はありません。"}</p>
                </article>
            </a>""")

# HTMLファイルの生成
html_content = HTML_TEMPLATE_1 + "\n".join(links) + HTML_TEMPLATE_2
with open("public/index.html", "w", encoding="utf-8") as html_file:
    html_file.write(html_content)

print("index.html が作成されました")
