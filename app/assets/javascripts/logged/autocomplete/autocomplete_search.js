$(document).on('turbolinks:load', function() {
  $('.ahead-query').typeahead(null, {
    source: window.autocomplete_search
  }).on('typeahead:selected', function(e, data) {
    $(event.target).closest("form").find("input[type=submit]").click();
  });
});

$(document).on('turbolinks:before-cache', function() { //solves the bug when users goes back
  $('.ahead-query').typeahead("destroy");
});
