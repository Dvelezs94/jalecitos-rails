$(document).on('turbolinks:load', function() {
  if ($('#google_autocomplete').length > 0) {
    activatePlacesSearch();
  }
});
