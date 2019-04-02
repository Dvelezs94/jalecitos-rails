$(document).on('turbolinks:load', function() {
  if ($(".name-class").length > 0) {
    init_char_N_count();
  }
});

function init_char_N_count() {
  nameInputs = $(".name-class");
  nameInputs.keyup(char_N_count);
  $.each(nameInputs, function(index, input) {
    $(input).before("<label id='count_N_" + $(input)[0].className.split(" ")[1].match(/\d+$/)[0] + "' class='count'></label>");
    $(input).keyup();
  });
}
function char_N_count() {
  number = $(this)[0].className.split(" ")[1].match(/\d+$/)[0];
  input = $(this).val();
  noHtml = input.replace(/<[^>]*>/g, "");
  noHtml = noHtml.replace(/&nbsp;/g, " ");
  $("#count_N_" + number).text((100 - noHtml.length) + "/100");
  textColor(noHtml.length,"#count_N_", number);
}
