$(document).on('turbolinks:load', function() {
  $("#message_image").change(function(){
  $("#file-name").text(this.files[0].name);
  });
});
