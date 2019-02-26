function activatePlacesSearch() {
  var search_input = document.getElementById('google_autocomplete');
  var options = {
    componentRestrictions: {
      country: "mx"
    }
  };
  var search_autocomplete = new google.maps.places.Autocomplete(search_input, options)
  // function to update lat and lon on the view
  // 
  // google.maps.event.addListener(search_autocomplete, 'place_changed', function () {
  //     var place = search_autocomplete.getPlace();
  //     document.getElementById('order_lat').value = place.geometry.location.lat();
  //     document.getElementById('order_lon').value = place.geometry.location.lng();
  //
  // });
}
