function activatePlacesSearch() {
  var search_input = document.getElementById('search_autocomplete');
  var form_input = document.getElementById('form_autocomplete');
  var options = {
    types: ['(cities)'],
    componentRestrictions: {
      country: "mx"
    }
  };
  var search_autocomplete = new google.maps.places.Autocomplete(search_input, options)
  if (form_input) {
    var form_autocomplete = new google.maps.places.Autocomplete(form_input, options)
  }
}

function activateBestSearch() {
  waitForElement(".best_google_input", function() {
    var array = document.getElementsByClassName('best_google_input');
    var best_input = array[0];
    var options = {
      types: ['(cities)'],
      componentRestrictions: {
        country: "mx"
      }
    };
    var best_autocomplete = new google.maps.places.Autocomplete(best_input, options)
  });
}
