$(document).on('turbolinks:load', function() {
  $("#message_image").change(function(){
    $("[no-msg-img]").addClass("d-none");
    var reader = new FileReader();
    reader.onload = function(){
      $("#output").removeClass("d-none");
      $("#output").attr("src", reader.result);
    };
    reader.readAsDataURL(event.target.files[0]);
  });
});
