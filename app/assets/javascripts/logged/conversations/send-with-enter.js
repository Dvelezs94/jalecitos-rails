$(document).on('turbolinks:load', function() {
  if ($(".messages-list").length > 0) {
    $('#message-content').keypress(function(e) {
      //if just clicked enter...
      if (e.which == 13 && !event.shiftKey) {
        //dont do default
        e.preventDefault();
        //if the field contains something, send message
        if ($("#message-content")[0].value.replace(/\s/g, "") != "") {
          $('.new_message').submit();
        }
        //id not, clean field (maybe there are just spaces)
        else{
          $("#message-content")[0].value = "";
        }
      }
    });
  }
});
