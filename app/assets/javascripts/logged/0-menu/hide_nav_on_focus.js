$(document).on('turbolinks:load', function() {
  var _originalSize = screen.height * 0.75 // screen never changes (but its a little bit bigger in comparison with $(window).height()), this is an aprox to get in the middle of keyboard range
  if (screen.width <= 991) {
    $(window).resize(function() {
      //when keyboard shows up, window height gets smaller
      if ($(window).height() < _originalSize) { // keyboard show up
        $(".main_container").css("margin-bottom", "0");
        $('.phone-bottom-menu').hide();
      }
       else { //keyboard closed
        $(".main_container").css("margin-bottom", "9vh");
        $('.phone-bottom-menu').show();
      }
      message_view_height(); // use this if conversation is present
    });
  }
});
