document.addEventListener("turbolinks:load", function () {
    let like = document.getElementById("like")
    let dislike = document.getElementById("dislike")

    if (!like && !dislike) {
        return
    }

    let xhr = new XMLHttpRequest();
    xhr.responseType = 'json'

    like.onclick = function (evt) {
        evt.preventDefault();
        send_xhr_with_headers('like')
    };

    dislike.onclick = function (evt) {
        evt.preventDefault();
        send_xhr_with_headers('dislike')
    };

    xhr.onload = function () {
        if (xhr.response.kind === 'like') {
            like.classList.add('active')
            dislike.classList.remove('active')
            like.textContent = "Like " + xhr.response.likes_count
            dislike.textContent = "Dislike " + xhr.response.dislike_count
        } else if (xhr.response.kind === 'dislike') {
            like.classList.remove('active')
            dislike.classList.add('active')
            like.textContent = "Like " + xhr.response.likes_count
            dislike.textContent = "Dislike " + xhr.response.dislike_count
        }
    };

    function send_xhr_with_headers(kind) {
        xhr.open("POST", document.URL + '/' + kind);
        xhr.setRequestHeader("Accept", "application/json");
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.send()
    }
})
