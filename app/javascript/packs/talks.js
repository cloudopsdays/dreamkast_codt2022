$(function(){
    clearInterval(window.timer);
    console.log("timer activated");

    window.timer = setInterval(function(){
        console.log("sending logs...");
        tracker.track("watch_video", {
            track_name: "archive",
            talk_id: window.talk_id
        });
    }, 120 * 1000);
})