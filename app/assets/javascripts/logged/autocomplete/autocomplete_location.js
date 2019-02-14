$(document).on('turbolinks:load', function() {
  var autocomplete_search = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/autocomplete_location?query=%QUERY',
      wildcard: '%QUERY'
    }
  });


  $('#search_autocomplete').typeahead(null, {
    source: autocomplete_search
  });

  $('#form_autocomplete').typeahead(null, {
    source: autocomplete_search
  });
});
