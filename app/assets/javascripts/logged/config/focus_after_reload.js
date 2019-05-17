$(document).on('turbolinks:load', function() {
  if (focusAfterReload = $.getUrlVar("focusAfterReload")) {
      $("#"+focusAfterReload).focus();
  }
  if (bestFocusAfterReload = $.getUrlVar("bestFocusAfterReload")) {
      $("#"+bestFocusAfterReload).click();
  }
});
