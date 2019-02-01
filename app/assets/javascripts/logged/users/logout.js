$(document).on('turbolinks:load', function() {
  const isInStandaloneMode = () =>
      (window.matchMedia('(display-mode: standalone)').matches) || (window.navigator.standalone);

   if (isInStandaloneMode() && $("#destroy_session").length > 0) {
     var oldUrl = $("#destroy_session").attr("href"); // Get current url
     var outUrl = oldUrl.replace("pending", "mobile"); // Create new url
     $("#destroy_session").attr("href", outUrl);
     $("#destroy_session_tab").attr("href", outUrl);
  }

  // Destroy push subscriptions on closing session
  $("#destroy_session").on('click', function (event) {
    event.preventDefault();
    navigator.serviceWorker.ready
    .then((registration) => {
      registration.pushManager.getSubscription()
        .then((subscription) => {
          if (subscription) {
            dropSubscription(subscription);
            subscription.unsubscribe();
          }
        });
    });
  });

  $("#destroy_session_tab").on('click', function (event) {
    event.preventDefault();
    navigator.serviceWorker.ready
    .then((registration) => {
      registration.pushManager.getSubscription()
        .then((subscription) => {
          if (subscription) {
            dropSubscription(subscription);
            subscription.unsubscribe();
          }
        });
    });
  });

});
