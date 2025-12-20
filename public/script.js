function shareX() {
    const url = encodeURIComponent(window.location.href);
    const text = encodeURIComponent(document.title);
    window.open(`https://twitter.com/intent/tweet?text=${text}&url=${url}`, '_blank');
}
function shareMisskey() {
    const url = encodeURIComponent(window.location.href);
    const text = encodeURIComponent(document.title);
    window.open(`https://misskey-hub.net/share/?text=${text}&url=${url}`, '_blank');
}
function openFeedback(url, entryId) {
    const title = document.title;
    // タイトルをURLエンコードしてパラメータに結合
    const fullUrl = `${url}?usp=pp_url&${entryId}=${encodeURIComponent(title)}`;
    window.open(fullUrl, '_blank');
}
function copyInfo() {
    const title = document.title;
    const desc = document.querySelector('meta[name=\"description\"]')?.content || '';
    const url = window.location.href;
    const textToCopy = `${title}\n${desc}\n${url}`;

    navigator.clipboard.writeText(textToCopy).then(() => {
        const toast = document.getElementById('copy-toast');
        toast.classList.add('show');
        setTimeout(() => toast.classList.remove('show'), 3000);
    });
}
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.raw-html-embed').forEach(el => {
        // data-html属性からHTMLコードを取り出す
        const htmlContent = el.getAttribute('data-html');
        if (htmlContent) {
            // divタグ自体を、中身のHTMLコードで置き換える (outerHTML)
            el.outerHTML = htmlContent;

            // 注: scriptタグを含む埋め込みコード(Twitterなど)の場合、
            // 単純な置換ではスクリプトが実行されないことがあります。
            // その場合は iframe 系の埋め込みコードを使うのが最も安全です。
        }
    });
});
