$(document).on('turbolinks:load', function() {
  char_count();
});

function char_count() {
  if ($(".trix-input").length == 1) {
    function textColor(length) {
      if (length <= 1000) {
        $("#count")[0].style.color = "green";
      } else {
        $("#count")[0].style.color = "red";
      }
    }

    $(".trix-input").keyup(function() {
      input = $(this).val();
      noHtml = input.replace(/<[^>]*>/g, "");
      noHtml = noHtml.replace(/&nbsp/g, "");
      $("#count").text((1000 - noHtml.length) + "/1000");
      textColor(noHtml.length);
    });

    $(".button_groups").click(function() {
      $(".trix-input").keyup();
    });

    $(".button_groups").mouseup(function() {
      if ($(".undo")[0].disabled) {
        $(".trix-input").keyup();
      }
      if ($(".redo")[0].disabled) {
        $(".trix-input").keyup();
      }
    });
    $(".trix-input").before("<label id='count'></label>");

    $(".trix-input").keyup();
  }
}
