$(document).on('turbolinks:load', function() {
  //when submit form, dont show alert of leaving page
  $('form.confirm_leave').submit(function() {
    window.finished_form = true;
  });
  // $('form.confirm_leave').on('change keyup paste', ':input', function() {
  //   console.log("jaja");
  // });
});

//alert for leaving page
$(window).bind("beforeunload", function(event) {
  if ($(".confirm_leave").length > 0 && window.finished_form != true) {
    window.finished_form == false;
    event.returnValue = leave_options(); //this is on reload, not compatible for custom text with all browsers
    return event.returnValue;
  }
});
// useful when clicking links of the page
$(document).on("page:before-change turbolinks:before-visit", function() {
  if ($(".confirm_leave").length > 0) {
    return confirm(leave_options());
  }
});

function leave_options() {
  if ($(".gig_form").length > 0) {
    //visited all tabs
    if ($(".steps.clearfix li.disabled").length == 0) {
      //i am in gig tab, so maybe i have gig changes and package changes
      if ($(".steps.clearfix li").first().hasClass("current")) {
        if (window.changed) {
          return "Tus cambios en el Jale y paquetes no se guardarán";
        } else {
          return "Tus cambios en los paquetes no se guardarán";
        }
      }
      //not in gig tab and visited all tabs, so just package changes may not be saved
      else {
        return "Tus cambios en los paquetes no se guardarán";
      }
    }
    //not visited packages
    if ($(".steps.clearfix li.disabled").length == 1) {
      //i am in gig
      if ($(".steps.clearfix li").first().hasClass("current")) {
        if (window.changed) {
          return "No has completado el proceso, tus cambios en el Jale no se guardarán";
        } else {
          return "No has terminado el proceso, pero tu Jale se ha guardado y puedes reanudarlo cuando desees.";
        }
      }
      //i am in gallery
      else if (!$(".steps.clearfix li").first().hasClass("current")) {
        return "No has terminado el proceso, pero tu Jale se ha guardado y puedes reanudarlo cuando desees.";
      }
    }
    //not visited galleries or packages
    if ($(".steps.clearfix li.disabled").length == 2) {
      return "Tus progreso no se guardará.";
    }
  }
  else if ($(".req_form").length > 0) {
    if ($(".steps.clearfix li.disabled").length == 0) { //visited all tabs
      //i am in request tab, so maybe i have request changes
      if ($(".steps.clearfix li").first().hasClass("current")) {
        if (window.changed) {
          return "No se guardarán los cambios hechos al pedido";
        }
        else {
          return "Tus cambios se han guardado, puedes volver a editarlo cuando desees"
        }
      }
      else { //i am in gallery tab
        return "Tus cambios se han guardado, puedes volver a editarlo cuando desees";
      }
    }
    else if ($(".steps.clearfix li.disabled").length == 1) { //not visited gallery
      return "Tu progreso no se guardará";
    }
  }
  //not in gig form or request form
  else {
    return "Tus progreso no se guardará.";
  }
}
