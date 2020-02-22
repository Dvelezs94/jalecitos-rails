//this has number 2 respect the initializers of location autocompletes because otherwise blur doesnt work, maybe event declaration orders matters...
$(document).on('turbolinks:load', function() {
  //location autocompletes needs this events to better ui experience
  autocom_loc_func("#menu_autocomplete");
  autocom_loc_func("#search_autocomplete");
  autocom_loc_func("#form_autocomplete_gig");
  autocom_loc_func("#form_autocomplete_req");
  autocom_loc_func("#config_autocomplete");
});

//this is still useful on google because it autocompletes
function autocom_loc_func(id) {
  //remove info on click
  $(id).on("focus", function(e) {
    window.location_val = $(this).val();
    $(this).val("");
  });

  //if its search autocomplete, needs some filter behaviours
  // if (id == "#search_autocomplete" || id == "#search_autocomplete_mobile") {
  //   $(id).on("keydown", function(e) {
  //     var city_id = get_city_input(e.target);
  //     //if value of city is same...
  //     if (e.keyCode == 13 && city_id.val() == window.city_val) {
  //       event.preventDefault(); // prevent submitting form if user clicks enter, we will validate that
  //       //and if location is empty, user wants to search in all mexico
  //       if ($(this).val() == "") {
  //         city_id.val("");
  //         $(e.target).closest("form").submit();
  //       }
  //     }
  //   });
  // }

  // $(id).on("keydown", function(e) {
  //   var city_id = get_city_input(e.target);
  //   //erase value of location if something random is typped
  //   if (e.keyCode == 13 && city_id.val() == window.city_val && window.location_val != $(this).val()) {
  //     alert("Debes elegir alguna de las opciones proporcionadas");
  //     $(this).val("");
  //   }
  // });
  if (id == "#form_autocomplete_gig" || id == "#form_autocomplete_req" || id == "#menu_autocomplete" || id == "#search_autocomplete") {
    $(id).blur(function(e) {
        //if no option selected, retype location
        if ($(this).val() != window.location_val) {
          $(this).val(window.location_val);
       }
    });
   }
}
