$(document).on('turbolinks:load', function() {
  $('form#search-form').change(function(event) {
    //dont send form when location changes and not select one
    if (event.target.id != "search_autocomplete") $(this).closest('form').submit();
  });
});
