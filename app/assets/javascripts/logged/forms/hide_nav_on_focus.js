$(document).on('turbolinks:load', function() {
  var _originalSize = $(window).height()
  if (screen.width <= 991) {
    $(window).resize(function() {
      if ($(window).height() < _originalSize) { // keyboard show up
        $('.phone-bottom-menu').hide();
        $(".main_container").css("margin-bottom", "0");
      } else { //keyboard closed
        $(".main_container").css("margin-bottom", "9vh");
        $('.phone-bottom-menu').show();
      }
      message_view_height(); // use this if conversation is present
    });
  }
});
