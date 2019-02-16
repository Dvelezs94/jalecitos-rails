//this has number 2 respect the initializers of location autocompletes because otherwise blur doesnt work, maybe event declaration orders matters...
$(document).on('turbolinks:load', function() {
  //location autocompletes needs this events to better ui experience
  autocom_loc_func("#mobile_menu_autocomplete");
  autocom_loc_func("#search_autocomplete");
  autocom_loc_func("#form_autocomplete");
});

function autocom_loc_func(id) {
  //remove info on click
  $(id).on("focus", function() {
    window.location_val = $(this).val();
    $(this).val("");
  });
  //tell the users that they have to select one of the given options if they hit enter and his city_id nis unfilled
  //(enter doesnt work because form doesnt have submit button)
  $(id).on("keyup", function(e) {
    if (e.keyCode == 13 && $(e.target).closest("form").find(".city").val() == "") {
      alert("Debes elegir alguna de las opciones proporcionadas");
      $(this).val("");
    }
  });
  //retype the location if nothing is set
  $(id).blur(function(event) {
    $(this).val(window.location_val);
  });
}
