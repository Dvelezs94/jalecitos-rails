function activatePlacesSearch() {
  var search_input = document.getElementById('search_autocomplete');
  var form_input = document.getElementById('form_autocomplete');
  var options = {
    types: ['(cities)'],
    componentRestrictions: {
      country: "mx"
    }
  };
  var search_autocomplete = new google.maps.places.Autocomplete(search_input, options);
  search_autocomplete.addListener('place_changed', function(){fill(this, search_input);});
  if (form_input) {
    var form_autocomplete = new google.maps.places.Autocomplete(form_input, options);
    form_autocomplete.addListener('place_changed', function(){fill(this, form_input);});
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
    best_autocomplete.addListener('place_changed', function(){fill(this, best_input);});
  });
}

function fill(autocomplete, input) {
  var place = autocomplete.getPlace();
  $(input).val([place["address_components"][0].long_name, place["address_components"][1].long_name, place["address_components"][2].long_name].join(", "));
}
