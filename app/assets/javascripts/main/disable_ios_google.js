// Remove google sign in if user is on ios
$(document).on('turbolinks:load', function() {
  if ($(".google-login").length > 0) {
    // hide google
    if (isIos()) {
      $(".google-login").hide()
    }
  }
});
