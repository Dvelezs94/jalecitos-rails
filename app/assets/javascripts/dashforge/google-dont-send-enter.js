$(document).on('turbolinks:load', function() { // dont send google with enter
  $('#menu_autocomplete').on('keypress', function(event) {
    if (event.keyCode == 13) {
      event.preventDefault();
    }
  });
  $('#search_autocomplete').on('keypress', function(event) {
    if (event.keyCode == 13) {
      event.preventDefault();
    }
  });
});
