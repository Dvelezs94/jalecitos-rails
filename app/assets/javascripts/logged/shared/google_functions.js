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
    fill_and_submit(this, search_input, "desktop");
  });
  generate_event("#search_autocomplete");

  if (form_input) {
    var form_autocomplete = new google.maps.places.Autocomplete(form_input, options);
    form_autocomplete.addListener('place_changed', function() {
      fill_and_submit(this, form_input, "form");
    });
    generate_event("#form_autocomplete");
  }
}

function activateConfigSearch() {
  waitForElement("#configuration_autocomplete", function() {
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
      fill_and_submit(this, best_input, "configuration");
    });
    generate_event(".best_google_input");
  });
}

function activateMobileSearch() {
  waitForElement("#mobile_autocomplete", function() {
    var item = document.getElementsByClassName('mobile_google_input');
    var mobile_input = item[0];
    var options = {
      types: ['(cities)'],
      componentRestrictions: {
        country: "mx"
      }
    };
    var mobile_autocomplete = new google.maps.places.Autocomplete(mobile_input, options);
    mobile_autocomplete.addListener('place_changed', function() {
      fill_and_submit(this, mobile_input, "mobile");
    });
    generate_event(".mobile_google_input");
  });
}

function fill_and_submit(autocomplete, input, name) {
  var place = autocomplete.getPlace();
  $(input).val([place["address_components"][0].long_name, place["address_components"][1].long_name, place["address_components"][2].long_name].join(", "));
  //use this just for best_in_place
  //hide and show map marker icon
  if (name == "mobile") {
    $(".mobile-location-item").css("display", "inline-block");
  }
  //send best in place form
  $(input).closest("form.form_in_place").submit();

}

function generate_event(id_or_class) {
  $('body').on('keydown', id_or_class, function(event) {
    if (event.keyCode === 13) {
      event.preventDefault();
    }
  });
}
