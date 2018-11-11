$(document).on('turbolinks:load', function() {
  if ($(".name-class").length > 0) {
    init_char_N_count();
  }
});

function init_char_N_count() {

  nameInputs = $(".name-class");
    $(".name-class").keyup(char_N_count);
  for (var i = 0; i < trixInputs.length; i++) {
    $(".name-" + i).before("<label id='count_N_" + i + "' class='count'></label>");
    $(".name-" + i).keyup();
  }
}
function char_N_count() {
  number = $(this)[0].className.split(" ")[1].match(/\d+$/)[0];
  input = $(this).val();
  noHtml = input.replace(/<[^>]*>/g, "");
  noHtml = noHtml.replace(/&nbsp;/g, " ");
  $("#count_N_" + number).text((100 - noHtml.length) + "/100");
  textColor(noHtml.length,"#count_N_", number);
}
