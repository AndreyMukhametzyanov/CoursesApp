document.addEventListener("turbolinks:load", function (event) {
    const timer = document.getElementById("timer")
    const form = document.getElementById("question-form")
    let seconds = parseInt(timer.dataset.time)
    timer.innerHTML = secToTimeString(seconds)
    setInterval(function () {
        if (seconds <= 0) {
            form.submit()
            return
        }
        seconds--
        timer.innerHTML = secToTimeString(seconds)
    }, 1000)
})


function secToTimeString(sec) {
    const addZero = function (n) {
        return n < 10 ? "0" + n : n
    }
    return [
        addZero(Math.floor(sec / 3600)),
        addZero(Math.floor(sec % 3600 / 60)),
        addZero(Math.floor(sec % 60))
    ].join(":")
}
