document.addEventListener("DOMContentLoaded", () => {
    const loadHTML = (selector, file) => {
        fetch(file)
            .then(response => {
                if (!response.ok) throw new Error("HTTPエラー " + response.status);
                return response.text();
            })
            .then(html => document.querySelector(selector).innerHTML = html)
            .catch(error => console.error("エラー:", error));
    };

    loadHTML("header", "header.html");
    loadHTML("footer", "footer.html");
});