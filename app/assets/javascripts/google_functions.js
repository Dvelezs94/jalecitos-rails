function activatePlacesSearch(){
  var input = document.getElementById('autocomplete');
  var options = {
  types: ['(cities)'],
  componentRestrictions: {country: "mx"}
 };
  var autocomplete = new google.maps.places.Autocomplete(input, options)
}
