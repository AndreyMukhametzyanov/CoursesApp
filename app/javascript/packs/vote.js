// { status: :ok, kind: kind.to_sym, likes_count: @likes_count, dislike_count: @dislikes_count }

document.addEventListener("turbolinks:load", function () {
    let like = document.getElementById("like")
    let dislike = document.getElementById("dislike")

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
            console.log(xhr.response)
            console.log(xhr.response.kind)
            console.log(xhr.response.likes_count)

            like.classList.add('active')
            dislike.classList.remove('active')
            like.textContent = "Like " + xhr.response.likes_count
            dislike.textContent = "Dislike " + xhr.response.dislike_count
        } else if (xhr.response.kind === 'dislike') {
            console.log(xhr.response)
            console.log(xhr.response.kind)
            console.log(xhr.response.dislike_count)

            like.classList.remove('active')
            dislike.classList.add('active')
            like.textContent = "Like " + xhr.response.likes_count
            dislike.textContent = "Dislike " + xhr.response.dislike_count
        } else {
            console.log(xhr.response)
        }
    };

    function send_xhr_with_headers(kind) {
        xhr.open("POST", document.URL + '/' + kind);
        xhr.setRequestHeader("Accept", "application/json");
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.send()
    }
})




