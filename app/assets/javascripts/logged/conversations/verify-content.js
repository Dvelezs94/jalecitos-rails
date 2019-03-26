$(document).on('turbolinks:load', function() {
  if ($(".messages-list").length > 0) {
    $('#new_message').submit(function() {
      if ($("#message_body")[0].value.replace(/\s/g, "") != "" || $("#message_image").val() != "") { //check if theres a message or image
        $('#attach-i').show();
        $(this).submit();
       }
      else {
        $("#message_body")[0].value = "";
        $("#message_body").focus();
        $('#attach-i').show();
        return false;
      }
    });
  }
});
