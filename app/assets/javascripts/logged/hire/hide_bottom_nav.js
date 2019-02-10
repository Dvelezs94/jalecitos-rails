$(document).on('turbolinks:load', function() {
  if ($(".pagar-area-for-tablet-mobile").length > 0) {
    $(".phone-bottom-menu").hide();
  }
});
