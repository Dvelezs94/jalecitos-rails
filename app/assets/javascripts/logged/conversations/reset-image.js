$(document).on('turbolinks:load', function() {
  $("#file-name").on("click", function(){
    $("#message_image").val('');
    $('#file-name')[0].innerText = "";
    $('#attach-i').show();
  });
});
