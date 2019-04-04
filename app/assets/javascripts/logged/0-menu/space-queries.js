$(document).on('turbolinks:load', function() {
  margin_top_results();
  $(window).resize(function(){
    margin_top_results();
  });
});

function margin_top_results() {
  if ($("#phone-bottom-menu").is(":visible") && $(".mobile-query").length > 0) { //if mobile size and query
    $(".search_results").css("margin-top", "100px");
  }
  else {
    $(".search_results").css("margin-top", "0");
  }
}
