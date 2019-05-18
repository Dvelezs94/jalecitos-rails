$(document).on('turbolinks:load', function() {
  if (window.location.href.indexOf("configuration") > -1) {
    //prevent making card or bank without name for user experience
    $("#cardbtn2").on("click", function() {
      if( $("#change_user_name").hasClass("bip-placeholder") ) { //means no value, using placeholder
        focus_best_span("change_user_name");
        show_error("Asegúrate de tener tu nombre completo en Jalecitos antes de agregar una tarjeta");
      }
    });
    $("#bankbtn2").on("click", function() {
      if( $("#change_user_name").hasClass("bip-placeholder") ) { //means no value, using placeholder
        focus_best_span("change_user_name");
        show_error("Asegúrate de tener tu nombre completo en Jalecitos antes de agregar un banco");
      }
    });
  }
});
