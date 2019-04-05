$(document).on('turbolinks:load', function() {
  margin_top_results();
  $(window).resize(function(){
    margin_top_results();
  });
});

function margin_top_results() {
  //if mobile search bar is visible need a margin top in results
  if ($(".mobile_search_bar").is(":visible")){
    $(".search_results").css("margin-top", "110px");
  }
  else {
    $(".search_results").css("margin-top", "0");
  }
}
