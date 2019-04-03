$(document).on('turbolinks:load', function() {
  if ($(".question_hint.toggler").length > 0) {

    //in phone, when uses clicks a hint display it
    $(".question_hint.toggler").on("click", function() {
      $(this).closest("div.form_block").find(".tooltiptext").toggleClass("displayed");
    });
    //direct click on hint also hides it
    $(".tooltiptext").on("click", function() {
      if (window.innerWidth < 1017) {
        $(this).toggleClass("displayed");
      }
    });
    //if user resizes, remove displayed of all hints (in desktop css is in charge of displaying hints with hover)
    $(window).resize(function() {
      if (window.innerWidth >= 1017) {
        $('.tooltiptext').removeClass('displayed');
      }
    });
  }
});
