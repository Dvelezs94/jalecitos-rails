$(document).on('turbolinks:load', function() {
  $("#output").on("click", function(event){
    event.preventDefault(); //the default is that when clicks it opens files to select another
    $("#message_image").val('');
    $("#output").attr("src", "");
    $("#output").attr("display", "none");
    $('#attach-i').show();
  });
});
