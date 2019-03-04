$(document).on('turbolinks:load', function() {
  //  when loggging in from mobile, ask for notification permission
  if ($.getUrlVar("notifications") == "enable") {
    Notification.requestPermission(function(status) {
      if (Notification.permission === "granted") {
        navigator.serviceWorker.ready.then(() => {
          createFirebaseSubscription();
        });
      }
    });
  }
});
