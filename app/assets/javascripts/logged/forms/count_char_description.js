$(document).on('turbolinks:load', function() {
  if ($(".description-class").length > 0) {
    init_char_D_count();
  }
});

function init_char_D_count() {

  descInputs = $(".description-class");
  descInputs.keyup(char_D_count);
  $.each(descInputs, function( index, input ) {
    $(input).before("<label id='count_D_" + $(input)[0].className.split(" ")[1].match(/\d+$/)[0] + "' class='count'></label>");
    $(input).keyup();
  });
}
function char_D_count() {
  number = $(this)[0].className.split(" ")[1].match(/\d+$/)[0];
  input = $(this).val();
  noHtml = input.replace(/<[^>]*>/g, "");
  noHtml = noHtml.replace(/&nbsp;/g, " ");
  $("#count_D_" + number).text((1000 - noHtml.length) + "/1000");
  textColor(noHtml.length,"#count_D_", number);
}
