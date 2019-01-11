$(document).on('turbolinks:load', function() {
  var autocomplete = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/autocomplete?query=%QUERY',
      replace: function(url, uriEncodedQuery) {
        model = $('#model_name').val();
        category = $("#category-select").val();
        loc = $("#search_autocomplete").val();

        return url.replace("%QUERY", uriEncodedQuery) + '&model_name=' + model + '&category_id=' + category + '&location=' + loc
      },
      wildcard: '%QUERY'
    }
  });


  $('#query').typeahead(null, {
    source: autocomplete
  });
});
