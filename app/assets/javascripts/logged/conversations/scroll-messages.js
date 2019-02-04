$(document).on('turbolinks:load', function() {
  if ($(".message_view_box").length > 0) {
    $(".message_view_box").scrollTop($(".message_view_box")[0].scrollHeight);
  }
});
