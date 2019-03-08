$(document).on('turbolinks:load', function() {
  if (screen.width <= 991) {
    var _originalSize = $(window).width() + $(window).height()
    $(window).resize(function() {
      if ($(window).width() + $(window).height() != _originalSize) {
        $('.phone-bottom-menu').hide(); // keyboard show up
      } else {
        $('.phone-bottom-menu').show(); //keyboard closed
      }
    });
  }
});
