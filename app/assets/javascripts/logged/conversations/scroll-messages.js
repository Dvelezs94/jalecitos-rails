$(document).on('turbolinks:load', function() {
  if ($(".messages-list").length > 0) {
    $(".messages-list").scrollTop($(".messages-list")[0].scrollHeight);
  }
});
