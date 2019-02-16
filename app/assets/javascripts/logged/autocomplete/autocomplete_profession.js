$(document).on('turbolinks:load', function() {
  if ($('#gig_profession').length == 1 || $('#request_profession').length == 1) {

    if ($('#gig_profession').length == 1) {
      $('#gig_profession').typeahead(null, {
        source: window.autocomplete_profession
      });
    } else {
      $('#request_profession').typeahead(null, {
        source: window.autocomplete_profession
      });
    }
  }
});
