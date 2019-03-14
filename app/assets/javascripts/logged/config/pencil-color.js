$(document).on('turbolinks:load', function() {
  if ($("span.best_in_place").length > 0){
    window.best_focus = false;
    $("body").on("click", function(event) {
      var elem = $(event.target);
      $(".toggable").removeClass("fa-check green");
      $(".toggable").addClass("fa-pencil-alt");

      if (elem.hasClass("best_in_place") || elem.hasClass("best_input") ){
        window.best_focus = true;
        elem.closest("div").find("i").removeClass("fa-pencil-alt");
        elem.closest("div").find("i").addClass("fa-check green");
      }
      else if (elem.hasClass("toggable") && window.best_focus == true) {
        window.best_focus = false;
      }
      else if (elem.hasClass("toggable") && window.best_focus == false){
        window.best_focus == true;
        elem.closest('div').find('span.best_in_place').click();
      }
      else {
        window.best_focus = false;
      }
    });
    $("body").focusout(function() {
      $(".toggable").removeClass("fa-check green");
      $(".toggable").addClass("fa-pencil-alt");
    });
    $(".best_input").focusout(function() {
      $(".toggable").removeClass("fa-check green");
      $(".toggable").addClass("fa-pencil-alt");
    });
}
});
