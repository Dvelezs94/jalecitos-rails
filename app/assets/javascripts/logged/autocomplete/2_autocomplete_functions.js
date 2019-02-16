//this has number 2 respect the initializers of location autocompletes because otherwise blur doesnt work, maybe event declaration orders matters...
$(document).on('turbolinks:load', function() {
  //location autocompletes needs this events to better ui experience
  autocom_loc_func("#mobile_menu_autocomplete");
  autocom_loc_func("#search_autocomplete");
  autocom_loc_func("#form_autocomplete");
});

function autocom_loc_func(id) {
  //remove info on click
  $(id).on("focus", function(e) {
    window.location_val = $(this).val();
    window.city_val = $(e.target).closest("form").find(".city").val()
    $(this).val("");
  });
  //tell the users that they have to select one of the given options if they hit enter and his city_id nis unfilled
  //(sometimes enter doesnt work because form doesnt have submit button)
  $(id).on("keyup", function(e) {
    if (e.keyCode == 13 && $(e.target).closest("form").find(".city").val() == "" && window.accept_nil_loc != true) {
      alert("Debes elegir alguna de las opciones proporcionadas");
      $(this).val("");
    }
  });
  $(id).on("keydown", function(e) {
    //if value of city is same...
    if (e.keyCode == 13 && $(e.target).closest("form").find(".city").val() == window.city_val) {
      //if location is empty, user wants to search in all mexico
      if ($(this).val() == "" ) {
        $(e.target).closest("form").find(".city").val("");
        window.accept_nil_loc = true;
      }
      //restore the initial value of location if smething randon is typped
      else {
        $(this).val(window.location_val);
      }
    }
  });
  //retype the location if nothing is set
  $(id).blur(function(event) {
    $(this).val(window.location_val);
  });
}
