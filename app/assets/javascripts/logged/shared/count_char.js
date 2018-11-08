$(document).on('turbolinks:load', function() {
  if ((window.location.href.indexOf("gigs") > -1 || window.location.href.indexOf("requests") > -1) && (window.location.href.indexOf("edit") > -1 || window.location.href.indexOf("new"))) {

    $(".trix-input").keyup(function() {
      input = $(this).val();
      noHtml = input.replace(/<[^>]*>/g, "");
      noHtml = noHtml.replace(/&nbsp/g, "");
      $("#count").text((1000 - noHtml.length) + "/1000");
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


    $( "#trix-toolbar-1" ).after( "<label id='count'></label>" );
    $(".trix-input").keyup();
  }
});
