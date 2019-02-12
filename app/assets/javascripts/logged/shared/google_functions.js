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
  search_autocomplete.addListener('place_changed', function() {
    fill_and_submit(this, search_input);
  });
  generate_event("#search_autocomplete");

  if (form_input) {
    var form_autocomplete = new google.maps.places.Autocomplete(form_input, options);
    form_autocomplete.addListener('place_changed', function() {
      fill_and_submit(this, form_input);
    });
    generate_event("#form_autocomplete");
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
    var best_autocomplete = new google.maps.places.Autocomplete(best_input, options);
    best_autocomplete.addListener('place_changed', function() {
      fill_and_submit(this, best_input);
    });
    generate_event(".best_google_input");
  });
}

function fill_and_submit(autocomplete, input) {
  var place = autocomplete.getPlace();
  $(input).val([place["address_components"][0].long_name, place["address_components"][1].long_name, place["address_components"][2].long_name].join(", "));
  //use this just for best_in_place
  $(input).closest("form.form_in_place").submit();
}

function generate_event(id_or_class) {
  $('body').on('keydown', id_or_class, function(event) {
    if (event.keyCode === 13) {
      event.preventDefault();
    }
  });
}
