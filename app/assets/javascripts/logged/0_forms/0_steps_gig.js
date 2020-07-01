$(document).on('turbolinks:load', function() {
  if ($(".gig_form").length > 0) {

    var form_cont = $("#section_parent_gig");

    window.gig_step = form_cont.steps({
      headerTag: "h3",
      bodyTag: "section",
      transitionEffect: "slideLeft",
      titleTemplate: '<span class="number">#index#</span> <span class="title">#title#</span>',
      labels: {
        previous: "Anterior",
        next: "Siguiente",
        finish: "Finalizar"
      },
      onInit: function(event, currentIndex) {
        form = $(".gig_form");
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
        form = form_cont.find("#section_parent_gig-p-" + currentIndex + " form").first();
        if (form.valid()) {
          syncAjaxGig(form);
          if (currentIndex == 0) update_faq_accordion(); //in case of creation, erases preview faqs when gig form is submitted. better ux
          return true;
        } else {
          return false;
        }
      },
      onStepChanged: function(event, currentIndex, newIndex) {
        window.changed = false; //restart at no changes
        return true;
      },
      onFinishing: function(event, currentIndex) {
        form = form_cont.find("#section_parent_gig-p-" + currentIndex + " form");
        if (form.valid() && validatePackages()) {
          $("a[href='#finish']").html("Guardando...");
          syncAjaxGig(form);
          return true;
        } else {
          window.test = form
          return false;
        }
      },
      onFinished: function(event, currentIndex) {
        window.finished_form = true;
      }
    });
  }
});

function syncAjaxGig(form) {
  $.ajax({
    type: form.find("[name='_method']").val() || form[0].method,
    url: form[0].action,
    dataType: "script",
    data: form.find("[name!='_method']").serialize(),
    success: function() {},
    error: function() {
      $("a[href='#finish']").html("Finalizar");
      show_error("Parece que no estás conectado a internet, intenta guardar de nuevo");
      if (form.hasClass("gig_form")) { //if its gig form, go again to it...
        setTimeout(function() { //if steps changes rapidly between steps, it crashes, i have to wait
          window.gig_step.steps("setStep", 0);
        }, 800);
      }
    }
  });
}

$.fn.steps.setStep = function(step) {
  var currentIndex = $(this).steps('getCurrentIndex');
  for (var i = 0; i < Math.abs(step - currentIndex); i++) {
    if (step > currentIndex) {
      $(this).steps('next');
    } else {
      $(this).steps('previous');
    }
  }
};
