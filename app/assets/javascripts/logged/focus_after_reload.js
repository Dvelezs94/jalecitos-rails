$(document).on('turbolinks:load', function() {
  if (focusAfterReload = $.getUrlVar("focusAfterReload")) {
      $("#"+focusAfterReload).focus();
  }
  if (bestFocusAfterReload = $.getUrlVar("bestFocusAfterReload")) {
    waitForElement("#"+bestFocusAfterReload, function() {
      focus_best_span(bestFocusAfterReload);
    });
  }
});
function focus_best_span(span_id) {
  $(".modal").hide(); //close all modals if necessary
  if ( $("[aria-controls=collapseOne]").hasClass("collapsed") ) {
    $("[aria-controls=collapseOne]").click(); //open first collapse if necessary
  }
  $("#"+span_id).click(); //click span
  $('html, body').animate({ //animate through screen
    scrollTop: ($("#"+span_id).offset().top-200)
  }, 1000);
}
