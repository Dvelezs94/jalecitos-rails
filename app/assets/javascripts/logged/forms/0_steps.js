$(document).on('turbolinks:load', function() {
  var form_cont = $("#section_parent");

  form_cont.steps({
    headerTag: "h3",
    bodyTag: "section",
    transitionEffect: "slideLeft",
    labels: {
      previous: "Anterior",
      next: "Siguiente",
      finish: "Finalizar"
    },
    onStepChanging: function(event, currentIndex, newIndex) {
      // Allways allow previous action even if the current form is not valid!
      if (currentIndex > newIndex) {
        return true;
      }
      // Needed in some cases if the user went back (clean up)
      if (currentIndex < newIndex) {
        // To remove error styles
        form_cont.find(".body:eq(" + newIndex + ") label.error").remove();
        form_cont.find(".body:eq(" + newIndex + ") .error").removeClass("error");
      }
      form = form_cont.find("#section_parent-p-" + currentIndex + " form");
      if (form.valid()) {
        return syncAjax(form).done(function(data, textStatus, jqXHR) {
          //wait until server response and return true or false
          proceed();
        });
      } else {
        return false
      }

    },
    onFinishing: function(event, currentIndex) {
      form = form_cont.find("#section_parent-p-" + currentIndex + " form");
      if (form.valid() && validatePackages()) {
        return syncAjax(form).done(function(data, textStatus, jqXHR) {
          //wait until server response and return true or false
          proceed();
        });
      } else {
        return false
      }
    },
    onFinished: function(event, currentIndex) {
      // nothing yet
    }
  })
});

function syncAjax(form) {
  window.success = false;
  return $.ajax({
    type: form.find("[name='_method']").val() || form[0].method,
    url: form[0].action,
    dataType: "script",
    data: form.find("[name!='_method']").serialize(),
    success: function() {},
    error: function() {}
  });
}

function proceed() {
  //window.success is set by server
  if (window.success) {
    return true;
  } else {
    return false;
    alert("Ha ocurrido un error, por favor, inténtelo de nuevo.");
  }
}
