$(document).on('turbolinks:load', function() {
  if ( $('#gig_profession').length == 1 ) {
    var autocomplete_profession = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.whitespace,
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
        url: '/autocomplete_profession?query=%QUERY',
        wildcard: '%QUERY'
      }
    });

    $('#gig_profession').typeahead(null, {
      source: autocomplete_profession
    });
  }
});
