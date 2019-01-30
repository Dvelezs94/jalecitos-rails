$(document).on('turbolinks:load', function() {
  var autocomplete_search = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/guest_autocomplete_search?query=%QUERY',
      replace: function(url, uriEncodedQuery) {

        lat = $('#lat').val();
        lon = $('#lon').val();

        return url.replace("%QUERY", uriEncodedQuery) + '&lat=' + lat + '&lon=' + lon
      },
      wildcard: '%QUERY'
    }
  });


  $('#query').typeahead(null, {
    source: autocomplete_search
  });
});
