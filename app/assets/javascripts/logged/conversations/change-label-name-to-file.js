$(document).on('turbolinks:load', function() {
  $("#message_image").change(function(){
    $('#attach-i').hide();
    var reader = new FileReader();
    reader.onload = function(){
      var output = document.getElementById('output');
      output.style.display = "block";
      output.src = reader.result;
    };
    reader.readAsDataURL(event.target.files[0]);
  });
});
