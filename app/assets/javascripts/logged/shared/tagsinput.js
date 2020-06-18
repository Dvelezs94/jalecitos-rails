$(document).on('turbolinks:load', function() {
  $('.tagsinput').tagsinput({
    maxTags: 20,
    maxChars: 50
    });
    $(".bootstrap-tagsinput").on("keyup", function(e){ //this fixes android bug of comma
      input = $(this).find("input");
      if (input.val()[input.val().length-1] == ",") {
        $("input").blur();
          $(this).click();
        }
    })
});
