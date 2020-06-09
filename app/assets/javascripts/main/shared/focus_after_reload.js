$(document).on('turbolinks:load', function() {
  focus_after_reload();
});
function focus_best_span(span_id) {
  $(".modal").hide(); //close all modals if necessary
  if ( $("[aria-controls=collapseOne]").attr("aria-expanded") == "false" ) {
    $("[aria-controls=collapseOne]").click(); //open first collapse if necessary
  }
  $("#"+span_id).click(); //click span
  $('html, body').animate({ //animate through screen
    scrollTop: ($("#"+span_id).offset().top-200)
  }, 1000);
}
function focus_after_reload() {
  if (focusAfterReload = $.getUrlVar("focusAfterReload")) {
    moveTo($("#"+focusAfterReload));
      $("#"+focusAfterReload).focus();
  }
  if (bestFocusAfterReload = $.getUrlVar("bestFocusAfterReload")) {
    waitForElement("#"+bestFocusAfterReload, function() {
      moveTo($("#"+focusAfterReload));
      focus_best_span(bestFocusAfterReload);
    });
  }
}
