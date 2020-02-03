$(document).on('turbolinks:load', function() {
  // if(window.innerWidth < 992)
  initGoogleAutocomplete("mobile_menu_autocomplete", "lat", "lng", "address_name", "user");
  //initGoogleAutocomplete("gmaps-input-address", "lat2", "lng2", "address_name2", true);
});


//the three hidden input are created by the function, you just have to specify their new ids
function initGoogleAutocomplete(input_id, lat_id, lng_id, address_name_id, model,map_id="") {
  waitForElement("#"+input_id, function() {
  //https://developers-dot-devsite-v2-prod.appspot.com/maps/documentation/javascript/examples/places-autocomplete-hotelsearch?hl=es-419
  //init autocomplete
  var search_input = document.getElementById(input_id);
  var Gkey = "<%= ENV.fetch('GOOGLE_MAP_API') %>";
  var options = {
    types: ['address'],
    // componentRestrictions: {country: "mx"}
  };
  var search_autocomplete = new google.maps.places.Autocomplete(search_input, options);
  //change values when autocomplete changes
  google.maps.event.addListener(search_autocomplete, 'place_changed', function () {
    getLatAndLng(this, address_name_id,lat_id, lng_id);
  });
  //create hidden fields where coordinates are stored
  $(search_input).after("<input type='hidden' name="+model+"["+ lat_id+"] id="+lat_id+">"+"<input type='hidden' name="+model+"["+lng_id+"] id="+lng_id+">"+"<input type='hidden' name="+model+"["+address_name_id+"] id="+address_name_id+">");
  //init map if id given
  if(map_id != ""){
    var map = new google.maps.Map(document.getElementById(map_id), {
      center: {lat: 19.432608, lng: -99.133209},
      zoom: 2
    });
    //change map when autocomplete changes
    search_autocomplete.addListener('place_changed', function(){
      updateMap(this, search_input, map);
    });
  }
  //extra events
  if(input_id == "mobile_menu_autocomplete"){
    search_autocomplete.addListener('place_changed', function(){
      $(search_input).closest("form").submit();
    });
  }
}); //end of waitForElement
}


//HELP FUNCTIONS
function updateMap(autocomplete, input, map) {
    place = autocomplete.getPlace();
    if (place.geometry) {
      map.panTo(place.geometry.location);
      map.setZoom(15);
    } else {
      input.value = '';
    }
}
function getLatAndLng(autocomplete, address_name_id,lat_id, lng_id){
  place = autocomplete.getPlace();
  document.getElementById(address_name_id).value = place.formatted_address;
  document.getElementById(lat_id).value = place.geometry.location.lat();
  document.getElementById(lng_id).value = place.geometry.location.lng();
}
