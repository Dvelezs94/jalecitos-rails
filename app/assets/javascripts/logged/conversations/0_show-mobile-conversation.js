$(document).on('turbolinks:load', function() {
  var width = $(window).width();
  var minwidth = 991;

  if (($.getUrlVar("user_id") != null) && width <= minwidth) {
    $(".messages-box-left-side").hide();
    // $('.headertop-right').hide();
    // $('.phone-bottom-menu').hide();
    $('.chat-right-side').show();
    $('.Harold-Bates-text h3 i').show(0, () => {
      scrollBottomMessages();
    });
  }
});
