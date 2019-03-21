// Remove google sign in if user is on ios
$(document).on('turbolinks:load', function() {
  if ($(".google-login").length > 0) {
    // Detects if device is on iOS
    const isIos = () => {
      const userAgent = window.navigator.userAgent.toLowerCase();
      return /iphone|ipad|ipod/.test( userAgent );
    }
    // hide google
    if (isIos()) {
      $(".google-login").hide()
    }
  }
});
