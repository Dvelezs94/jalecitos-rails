$(document).on('turbolinks:load', function() {

  $('#search_autocomplete').typeahead(null, {
    source: window.autocomplete_location
  });

  $('.mobile_menu_autocomplete').typeahead(null, {
    source: window.autocomplete_location
  });

  $('#form_autocomplete').typeahead(null, {
    source: window.autocomplete_location
  });
});
