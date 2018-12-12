$(document).on('turbolinks:load', function() {
  $("#file-name").on("click", function(){
    $("#message_image").value = "";
    $('#file-name')[0].innerText = "";
  });
});
