//remove placeholder on click
$(document).on('turbolinks:load', function() {
  $("#mobile_menu_autocomplete").on("focus", function() {
    window.location_val =  $(this).val();
    $(this).val("");
  });
//tell the users that they have to select one of the given options (enter doesnt work because form doesnt have submit button)
  $("#mobile_menu_autocomplete").on("keyup", function(e) {
    if (e.keyCode == 13 && window.form_submitted != true) {
    alert("Debes elegir alguna de las opciones proporcionadas");
    $(this).val("");
    }
  });
//retype the location if nothing is not sent
  $("#mobile_menu_autocomplete").blur( function(event) {
    event.preventDefault();
    $(this).val(window.location_val);
  });

});
