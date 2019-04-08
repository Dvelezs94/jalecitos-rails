//this has number 2 respect the initializers of location autocompletes because otherwise blur doesnt work, maybe event declaration orders matters...
$(document).on('turbolinks:load', function() {
  //location autocompletes needs this events to better ui experience
  autocom_loc_func("#mobile_menu_autocomplete");
  autocom_loc_func(".search_autocomplete");
  autocom_loc_func("#form_autocomplete");
  autocom_loc_func("#config_autocomplete");
});

function autocom_loc_func(id_or_class) {
  //remove info on click
  $(id_or_class).on("focus", function(e) {
    var city_id = get_city_input(e.target);
    window.location_val = $(this).val();
    window.city_val = city_id.val();
    $(this).val("");
  });

  //if its search autocomplete, needs some filter behaviours
  if (id_or_class== ".search_autocomplete") {
    $(id_or_class).on("keydown", function(e) {
      var city_id = get_city_input(e.target);
      //if value of city is same...
      if (e.keyCode == 13 && city_id.val() == window.city_val) {
        event.preventDefault(); // prevent submitting form if user clicks enter, we will validate that
        //and if location is empty, user wants to search in all mexico
        if ($(this).val() == "") {
          city_id.val("");
          $(e.target).closest("form").submit();
        }
      }
    });
  }

  $(id_or_class).on("keydown", function(e) {
    var city_id = get_city_input(e.target);
    //erase value of location if something random is typped
    if (e.keyCode == 13 && city_id.val() == window.city_val && window.location_val != $(this).val()) {
      alert("Debes elegir alguna de las opciones proporcionadas");
      $(this).val("");
    }

  });
  if (id_or_class == "#form_autocomplete") {
    $(id_or_class).blur(function(e) {
      var city_id = get_city_input(e.target);
      //if id is same...
      if (city_id.val() == window.city_val) {
        //and value isnt empty, retype location
        if ($(this).val() != "") {
          $(this).val(window.location_val);
        }
       }
    });
  } else {
    //retype the location if nothing is set
    $(id_or_class).blur(function(e) {
      $(this).val(window.location_val);
    });
  }
}

function get_city_input(loc_input) {
  return $(loc_input).closest("form").find(".city");
}
