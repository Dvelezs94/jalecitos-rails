$(document).on('turbolinks:load', function() {
  if ($(".req_form").length > 0) {
    //detecting changes on each form
    $(document).on('change keyup paste', ':input', function() {
      window.changed = true;
    });
    var form_cont = $("#section_parent_req");
    window.req_step = form_cont.steps({
      headerTag: "h3",
      bodyTag: "section",
      transitionEffect: "slideLeft",
      labels: {
        previous: "Anterior",
        next: "Siguiente",
        finish: "Finalizar"
      },
      onInit: function(event, currentIndex) {
        form = $(".req_form");
        //this input exist only when form has method different than post or get, so i am confirming if i am on update (patch)
        if (form.find("[name='_method']").val()) {
          $(".steps.clearfix li").not(":eq(0)").removeClass("disabled");
          $(".steps.clearfix li").not(":eq(0)").addClass("done");
        }
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
        form = form_cont.find("#section_parent_req-p-" + currentIndex + " form").first();
        if (form.valid()) {
          syncAjaxReq(form);
          return true;
        } else {
          return false
        }

      },
      onStepChanged: function(event, currentIndex, newIndex) {
        window.changed = false; //restart at no changes
        return true;
      },
      onFinishing: function(event, currentIndex) {
        form = form_cont.find("#section_parent_req-p-" + currentIndex + " form").first();
        $("a[href='#finish']").html("Guardando...");
        syncAjaxReq(form)
        return true;
      },
      onFinished: function(event, currentIndex) {
        window.finished_form = true;
      }
    });
  }
});

function syncAjaxReq(form) {
  return $.ajax({
    type: form.find("[name='_method']").val() || form[0].method,
    url: form[0].action,
    dataType: "script",
    data: form.find("[name!='_method']").serialize(),
    success: function() {},
    error: function() {
      $("a[href='#finish']").html("Finalizar");
      show_error("Parece que no estás conectado a internet, intenta guardar de nuevo");
      if (form.hasClass("req_form")) { //if its gig form, go again to it...
        setTimeout(function() { //if steps changes rapidly between steps, it crashes, i have to wait
          window.req_step.steps("setStep", 0);
        }, 800);
      }
    }
  });
}
