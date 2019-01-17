$(document).on('turbolinks:load', function() {
  if (location.pathname == "/") {
    if (Notification.permission === "granted") {
      navigator.serviceWorker.ready.then(() => {
        validateSWSubscription();
      });
    }
  }
});
