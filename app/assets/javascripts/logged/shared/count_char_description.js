$(document).on('turbolinks:load', function() {
  if ($(".trix-class").length > 0) {
    // eraseLastSpace();
    init_char_count();
  }
});

function init_char_count() {
  $("trix-editor").keyup(char_count);
  $("trix-toolbar").click(function() {
    $("trix-editor[toolbar="+this.id+"]").keyup();
  });
  $("trix-toolbar").mouseup(function() {
    if ($("#" + this.id + " .undo")[0].disabled) {
      $("trix-editor[toolbar="+this.id+"]").keyup();
    }
    if ($("#" + this.id + " .redo")[0].disabled) {
      $("trix-editor[toolbar="+this.id+"]").keyup();
    }
  });
  trixInputs = $(".trix-class");
  for (var i = 0; i < trixInputs.length; i++) {
    $(".trix_input_" + i).before("<label id='count" + i + "' class='count'></label>");
    $(".trix_input_" + i).keyup();
  }
}
function textColor(length, number) {
  if (length <= 1000) {
    $("#count" + number)[0].style.color = "green";
  } else {
    $("#count" + number)[0].style.color = "red";
  }
}
function char_count() {
  number = $(this)[0].className.split(" ")[1].match(/\d+$/)[0];
  input = $(this).val();
  noHtml = input.replace(/<[^>]*>/g, "");
  noHtml = noHtml.replace(/&nbsp;/g, " ");
  $("#count" + number).text((1000 - noHtml.length) + "/1000");
  textColor(noHtml.length, number);
}
// function eraseLastSpace(){
//   trixInputs = $(".trix-class");
//   for (var i = 0; i < trixInputs.length; i++) {
//     $(".trix-class")[i].value = $(".trix-class")[i].value.replace(/&nbsp;/g,' ').trim();
//
//   }
// }
