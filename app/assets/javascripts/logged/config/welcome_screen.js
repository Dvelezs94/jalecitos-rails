function redirectToHome() {
  window.location.href = "/?modal=completeInfo";
}

$(document).on('turbolinks:load', function() {
  if (window.location.pathname == "/wizard") {
    var initialWidth = window.innerWidth;
    $("#navbarMenu").css("pointer-events", "none"); //prevent interaction with page, like open menu before
    $("[data-step]").css("pointer-events", "none");
    intro = introJs();
    intro.setOptions({ doneLabel : 'Finalizar', nextLabel: "siguiente", prevLabel: "Previo", skipLabel: "Finalizar" })
    intro.start()
    .onchange(function(targetElement) {
        if (this._currentStep === 3) {
          $("#mainMenuOpen").click(); //useful in phones so the burger menu open
        }
      })
      // clicking 'Done'
      .oncomplete(function() {
        redirectToHome();
      })

      // clicking 'Skip'
      .onexit(function() {
        redirectToHome();
      });
      $(window).resize(function() { //reload if resize because all can dissapear
        if ((initialWidth <= 991 && window.innerWidth > 991) ||  (initialWidth > 991 && window.innerWidth <= 991)) location.reload();
      });
  }
});
