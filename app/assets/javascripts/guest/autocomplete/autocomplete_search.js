$(document).on('turbolinks:load', function() {
  var autocomplete_search = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/guest_autocomplete_search?query=%QUERY',
      wildcard: '%QUERY'
    }
  });


  $('#query').typeahead(null, {
    source: autocomplete_search
  });
});
