//this have to load first
$(document).on('turbolinks:load', function() {

  window.autocomplete_search = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/autocomplete_search?query=%QUERY',
      wildcard: '%QUERY'
    }
  });

  window.autocomplete_location = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/autocomplete_location?query=%QUERY',
      wildcard: '%QUERY'
    }
  });

  window.autocomplete_profession = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/autocomplete_profession?query=%QUERY',
      wildcard: '%QUERY'
    }
  });
});
