$(document).on('turbolinks:load', function() {
  if ($(".trix-class").length > 0) {
    init_char_D_count();
  }
});

function init_char_D_count() {
  $("trix-editor").keyup(char_D_count);
  $("trix-toolbar").click(function() {
    $("trix-editor[toolbar=" + this.id + "]").keyup();
  });
  $("trix-toolbar").mouseup(function() {
    if ($("#" + this.id + " .undo")[0].disabled) {
      $("trix-editor[toolbar=" + this.id + "]").keyup();
    }
    if ($("#" + this.id + " .redo")[0].disabled) {
      $("trix-editor[toolbar=" + this.id + "]").keyup();
    }
  });
  trixInputs = $(".trix-class");
  for (var i = 0; i < trixInputs.length; i++) {
    $(".trix_input_" + i).before("<label id='count_D_" + i + "' class='count'></label>");
    $(".trix_input_" + i).keyup();
  }
}

function char_D_count() {
  number = $(this)[0].className.split(" ")[1].match(/\d+$/)[0];
  input = $(this).val();
  noHtml = input.replace(/<[^>]*>/g, "");
  noHtml = decodeHTMLEntities(noHtml);
  $("#count_D_" + number).text((1000 - noHtml.length) + "/1000");
  textColor(noHtml.length, "#count_D_", number);
}
