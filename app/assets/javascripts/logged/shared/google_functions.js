function activatePlacesSearch(){
  var search_input = document.getElementById('search_autocomplete');
  var form_input = document.getElementById('form_autocomplete');
  var options = {
    types: ['(cities)'],
    componentRestrictions: {country: "mx"}
  };
  var search_autocomplete = new google.maps.places.Autocomplete(search_input, options)
  if(form_input){
    var form_autocomplete = new google.maps.places.Autocomplete(form_input, options)
  }
}
