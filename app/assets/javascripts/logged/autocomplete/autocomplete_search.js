$(document).on('turbolinks:load', function() {
  $('#query').typeahead(null, {
    source: window.autocomplete_search
  }).on('typeahead:selected', function(e, data) {
    $(event.target).closest("form").find("input[type=submit]").click();
  });
});
