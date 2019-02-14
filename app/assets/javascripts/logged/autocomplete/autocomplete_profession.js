$(document).on('turbolinks:load', function() {
  if ($('#gig_profession').length == 1 || $('#request_profession').length == 1) {
    var autocomplete_profession = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.whitespace,
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
        url: '/autocomplete_profession?query=%QUERY',
        wildcard: '%QUERY'
      }
    });
    if ($('#gig_profession').length == 1) {
      $('#gig_profession').typeahead(null, {
        source: autocomplete_profession
      });
    } else {
      $('#request_profession').typeahead(null, {
        source: autocomplete_profession
      });
    }
  }
});
