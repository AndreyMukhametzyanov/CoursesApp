// { status: :ok, kind: kind.to_sym, likes_count: @likes_count, dislike_count: @dislikes_count }

document.addEventListener("turbolinks:load", function () {
    let like = document.getElementById("like")
    let dislike = document.getElementById("dislike")
    let like_count = 0;
    let dislike_count = 0;

    let xhr = new XMLHttpRequest();
    xhr.responseType = 'json'

    like.onclick = function (evt) {
        evt.preventDefault();
        xhr.open("POST", "http://127.0.0.1:3000/courses/1/lessons/14/like");
        xhr.setRequestHeader("Accept", "application/json");
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.send()
    };

    dislike.onclick = function (evt) {
        evt.preventDefault();
        xhr.open("POST", "http://127.0.0.1:3000/courses/1/lessons/14/dislike");
        xhr.setRequestHeader("Accept", "application/json");
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.send()
    };

    xhr.onload = function () {
        if (xhr.response.kind === 'like') {
            console.log(xhr.response)
            console.log(xhr.response.kind)
            console.log(xhr.response.likes_count)
        } else if (xhr.response.kind === 'dislike') {
            console.log(xhr.response)
            console.log(xhr.response.kind)
            console.log(xhr.response.dislike_count)
        }
    };
})




