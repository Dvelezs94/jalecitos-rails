$(document).on('turbolinks:load', function() {
  if ($("span.best_in_place").length > 0 ) {
    $(".google-span").click(function() {
      activateBestSearch();
    });
  }
});
