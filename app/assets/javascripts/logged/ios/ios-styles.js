$(document).on('turbolinks:load', function() {
  const isIos = () => {
    const userAgent = window.navigator.userAgent.toLowerCase();
    return /iphone|ipad|ipod/.test( userAgent );
  }
  // this js applies some styles so iphone x looks good
  if (isIos()) {
    // Detect if the ios device has a notch function
    if ($(".tablet-mobile-top-ber").length > 0) {
      $(".tablet-mobile-top-ber").css("padding-top", "env(safe-area-inset-top)");
    }
    if ($(".phone-bottom-menu").length > 0) {
      $(".phone-bottom-menu").css("padding-bottom", "env(safe-area-inset-bottom)");
    }
    if ($(".pagar-area-for-tablet-mobile").length > 0) {
      $(".pagar-area-for-tablet-mobile").css("padding-bottom", "env(safe-area-inset-bottom)");
    }

    // fix messages when ios keyboard is up
    if ($("#message_body").length > 0) {
      $('input').on("blur",function (e) {
        window.scrollTo(0,0);
      });
    }
    // change main_container margin top on notched devices
    // if less than 60 px, means notch device
    var checkMenu = setInterval(function() {
      window.menu_height = $("#main_menu").height();
      if (window.menu_height > 70) {
        $(".main_container").css("padding-top", "90px");
        clearInterval(checkMenu);
      }
      else{
        window.tries_count_3 += 1;
      }
      if (window.tries_count_3 == 10) { //if no notification, this will run always
        clearInterval(checkMenu);
      }
    }, 200)
  }
});
