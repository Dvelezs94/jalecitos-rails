$(document).on('turbolinks:load', function() {
  $("#message_image").change(function(){
    $('#attach-i').hide();
    $("#file-name").text(this.files[0].name);
  });
});
