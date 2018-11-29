$(document).on('turbolinks:load', function() {
  if ($(".messages-list").length > 0) {
    $('.new_message').submit(function() {
      if ($("#message-content")[0].value.replace(/\s/g, "") != "") {
        return true;
      } else {
        $("#message-content")[0].value = "";
        $("#message-content").focus();
        return false;
      }
    });
  }
});
