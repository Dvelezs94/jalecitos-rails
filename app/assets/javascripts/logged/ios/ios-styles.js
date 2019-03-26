$(document).on('turbolinks:load', function() {
  const isIos = () => {
    const userAgent = window.navigator.userAgent.toLowerCase();
    return /iphone|ipad|ipod/.test( userAgent );
  }
  // this js applies some styles so iphone x looks good
  if (isIos()) {
    if ($(".tablet-mobile-top-ber").length > 0) {
      $(".tablet-mobile-top-ber").css("padding-top", "env(safe-area-inset-top)");
    }
    if ($(".phone-bottom-menu").length > 0) {
      $(".phone-bottom-menu").css("padding-bottom", "env(safe-area-inset-bottom)");

    }
  }
});
