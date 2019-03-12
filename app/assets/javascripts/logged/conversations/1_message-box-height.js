function message_view_height () {
  screen_height = $(window).height();
  extra_padding = 50;
  upper_conversation_menu = $('.Harold-Bates-text h3:visible').outerHeight(true) || 0;
  mobile_nav = $('.phone-bottom-menu:visible').outerHeight(true) || 0;
  mobile_top_menu = $('.tablet-mobile-top-ber:visible').outerHeight(true) || 0;
  conversation_input = $('.bottom-chat-write:visible').outerHeight(true) || 0;
  desktop_top_menu = $('.header-to-area:visible').outerHeight(true) || 0;
  messages_height = screen_height - extra_padding - conversation_input - upper_conversation_menu - mobile_nav - mobile_top_menu - desktop_top_menu;
  $('.message_view_box').height(messages_height);
}

$(document).on('turbolinks:load', function() {
  if ($('.bottom-chat-write').length > 0) {
    message_view_height();
    $( window ).resize(function() {
      message_view_height();
    });
  }
});
