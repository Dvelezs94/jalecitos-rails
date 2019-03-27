$(document).on('turbolinks:load', function() {
  const isIos = () => {
    const userAgent = window.navigator.userAgent.toLowerCase();
    return /iphone|ipad|ipod/.test( userAgent );
  }
  // this js applies some styles so iphone x looks good
  if (isIos()) {
    // Detect if the ios device has a notch function
    function hasNotch() {
      if (CSS.supports('padding-bottom: env(safe-area-inset-bottom)')) {
        let div = document.createElement('div');
        div.style.paddingBottom = 'env(safe-area-inset-bottom)';
        document.body.appendChild(div);
        let calculatedPadding = parseInt(window.getComputedStyle(div).paddingBottom, 10);
        document.body.removeChild(div);
        if (calculatedPadding > 0) {
          return true;
        }
      }
      return false;
    }

    if ($(".tablet-mobile-top-ber").length > 0) {
      $(".tablet-mobile-top-ber").css("padding-top", "env(safe-area-inset-top)");
    }
    if ($(".phone-bottom-menu").length > 0) {
      $(".phone-bottom-menu").css("padding-bottom", "env(safe-area-inset-bottom)");
    }
    if ($(".pagar-area-for-tablet-mobile").length > 0) {
      $(".pagar-area-for-tablet-mobile").css("padding-bottom", "env(safe-area-inset-bottom)");
    }

    if ($("#message_body").length > 0) {
      $('input').on("blur",function (e) {
        window.scrollTo(0,0);
      });
    }
    // change main_container margin top on notched devices
    if (hasNotch()){
      if ($(".main_container").length > 0) {
        $(".main_container").css("margin-top", "90px");
      }
    }
  }
});
