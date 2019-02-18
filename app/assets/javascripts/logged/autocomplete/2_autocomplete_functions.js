//this has number 2 respect the initializers of location autocompletes because otherwise blur doesnt work, maybe event declaration orders matters...
$(document).on('turbolinks:load', function() {
  //location autocompletes needs this events to better ui experience
  autocom_loc_func("#mobile_menu_autocomplete");
  autocom_loc_func("#search_autocomplete");
  autocom_loc_func("#form_autocomplete");
  autocom_loc_func("#config_autocomplete");
});

function autocom_loc_func(id) {
  //remove info on click
  $(id).on("focus", function(e) {
    window.location_val = $(this).val();
    window.city_val = $(e.target).closest("form").find(".city").val()
    $(this).val("");
  });

  //if its search autocomplete, needs some filter behaviours
  if (id == "#search_autocomplete") {
    $(id).on("keydown", function(e) {
      //if value of city is same...
      if (e.keyCode == 13 && $(e.target).closest("form").find(".city").val() == window.city_val) {
        event.preventDefault(); // prevent submitting form if user clicks enter, we will validate that
        //and if location is empty, user wants to search in all mexico
        if ($(this).val() == "") {
          $(e.target).closest("form").find(".city").val("");
          $(e.target).closest("form").submit();
        }
      }
    });
  }
  $(id).on("keydown", function(e) {
      //erase value of location if something random is typped
    if (e.keyCode == 13 && $(e.target).closest("form").find(".city").val() == window.city_val && window.location_val != $(this).val()) {
      alert("Debes elegir alguna de las opciones proporcionadas");
      $(this).val("");
    }

  });
  //retype the location if nothing is set
  $(id).blur(function(event) {
    $(this).val(window.location_val);
  });
}
