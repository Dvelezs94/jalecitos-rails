$(document).on('turbolinks:load', function() {
  // if(window.innerWidth < 992)
  initGoogleAutocomplete("menu_autocomplete", "lat", "lng", "address_name", "user", "0", true);
  initGoogleAutocomplete("search_autocomplete", "lat", "lng", "address_name", "", "1", true);
  initGoogleAutocomplete("config_autocomplete", "lat", "lng", "address_name", "user", "2", true);
  initGoogleAutocomplete("form_autocomplete_gig", "lat", "lng", "address_name", "gig", "3", false);
  initGoogleAutocomplete("form_autocomplete_req", "lat", "lng", "address_name", "request", "4", false);
  initGoogleMap("searchmap");
  //initGoogleAutocomplete("gmaps-input-address", "lat2", "lng2", "address_name2", true);
  $(window).resize(function() {
    if ($("#filter_and_results").hasClass("d-none") && window.innerWidth > 767) {
      searchToggle();
    }
  });
});
window.markers = [];
function searchToggle() {
  container = $("#filter_and_results")
  container.toggleClass("d-none");
  //useful for displaying map of query without margins
  the_screen = $('[screen-wrapper="true"]')
  the_screen.toggleClass("screen-size-wrapper");
  the_screen.toggleClass("screen-size-wrapper-map");
  $("#filterBar").toggleClass("ht-1");
  $("#filterBar").toggleClass("pd-t-10");
}

function initGoogleMap(id) {
  waitForElement("#" + id, function() {
    window.searchmap = new google.maps.Map(document.getElementById(id), {
      center: {
        lat: parseFloat($("#search_autocomplete").attr("lat")) || 19.432608,
        lng: parseFloat($("#search_autocomplete").attr("lng")) || -99.133209
      },
      zoom: 15,
      fullscreenControl: false,
      zoomControl: true,
      mapTypeControl: false,
      scaleControl: true,
      streetViewControl: false,
      rotateControl: true
    });

    control_close = $("#google_control_close")[0];
    control_search = $("#google_control_search")[0];
    control_filter = $("#google_control_filter")[0];
    window.searchmap.controls[google.maps.ControlPosition.TOP_LEFT].push(control_close);
    window.searchmap.controls[google.maps.ControlPosition.TOP_CENTER].push(control_search);
    window.searchmap.controls[google.maps.ControlPosition.TOP_RIGHT].push(control_filter);
    load_pending_map_elements(window.searchmap);
    //get current center coordinates when moved
    google.maps.event.addListener(window.searchmap, "center_changed", function() {
      window.currentzoom = this.getZoom();
      if (window.currentzoom >= 12) {
        $("#google_control_search").removeAttr("disabled");
      }
      else {
        $("#google_control_search").attr("disabled", "true");
      }
    });
  });
}

function searchHere(){
  var geocoder = new google.maps.Geocoder;
  var search_button = $("#google_control_search");
  var latlng = {lat: window.searchmap.center.lat(), lng: window.searchmap.center.lng()};
  geocoder.geocode({'location': latlng}, function(results, status) {
  if (status === 'OK') {
    if (results[0]) {
      form = $("#search-form");
      form.find("#search_autocomplete").val(results[0].formatted_address);
      form.find("[name='lat']").val(results[0].geometry.location.lat());
      form.find("[name='lng']").val(results[0].geometry.location.lng());
      search_button.attr("disabled", "true");
      search_button.find("span").toggleClass("d-none");
      $("#search-form-submit").click();
    } else {
      // nothing
    }
  } else {
    console.log('Geocoder failed due to: ' + status);
  }
});
  search_button.removeAttr("disabled");
  search_button.find("span").toggleClass("d-none");
}

function goToElement(element){
  var lat = parseFloat(element.getAttribute("lat"));
  var lng = parseFloat(element.getAttribute("lng"));
  $.each( window.markers, function( index, marker ){
    markerLat = parseFloat(marker.position.lat());
    markerLng = parseFloat(marker.position.lng())
    if (markerLat == lat && markerLng == lng){
      if (window.activeInfowindow) window.activeInfowindow.close();
      window.searchmap.setZoom(15);
      google.maps.event.trigger(marker, 'click');
      window.searchmap.setCenter(new google.maps.LatLng(lat, lng));
    }
  });
}

function load_pending_map_elements(map, deleteOldMarkers=true) {
  if (deleteOldMarkers) DeleteMarkers();
  $("#searchList [loaded_in_map='false']").each(function(index, elem) {
    var infoTexts = "";
    var changedInfoWindow = false;
    //check other elements in same lat and lng
    var sameLoc = $("#searchList [loaded_in_map][lat='" + elem.getAttribute("lat") + "'][lng='" + elem.getAttribute("lng") + "']");
    sameLoc.each(function(index, elem2) {
      infoTexts += elem2.outerHTML;
      elem2.setAttribute("loaded_in_map", "true");
      if (elem2 == window.activeElem) changedInfoWindow = true;
    });
    //create marker
    var myLatlng = new google.maps.LatLng(elem.getAttribute("lat"), elem.getAttribute("lng"));
    var title = (sameLoc.length > 1) ? elem.getAttribute("title") + " y " + (sameLoc.length - 1) + " más" : elem.getAttribute("title");
    var marker = new google.maps.Marker({
      position: myLatlng,
      title: title,
      map: map
    });
    //infowindow of each marker

    var infowindow = new google.maps.InfoWindow({
      content: infoTexts
    });
    marker.addListener('click', function() {
      window.activeElem = elem;
      window.activeInfowindow = infowindow;
      feather.replace();
      infowindow.open(window.searchmap, marker);
    });
    window.markers.push(marker);
    if (changedInfoWindow)
      window.activeInfowindow.setContent(infoTexts);
  });
}

function DeleteMarkers() {
     //Loop through all the markers and remove
     for (var i = 0; i < window.markers.length; i++) {
         window.markers[i].setMap(null);
     }
     window.markers = [];
 };


//the three hidden input are created by the function, you just have to specify their new ids
function initGoogleAutocomplete(input_id, lat_name, lng_name, address_name, model, id_sufix, send_on_select = false, map_id = "") {
  waitForElement("#" + input_id, function() {
    //https://developers-dot-devsite-v2-prod.appspot.com/maps/documentation/javascript/examples/places-autocomplete-hotelsearch?hl=es-419
    //customize autocomplete
    var search_input = document.getElementById(input_id);
    var Gkey = "<%= ENV.fetch('GOOGLE_MAP_API') %>";
    var options = {
      // componentRestrictions: {country: "mx"}
    };
    //generate ids
    var lat_id = lat_name + id_sufix;
    var lng_id = lng_name + id_sufix;
    var address_id = address_name + id_sufix;
    //init autocomplete
    var search_autocomplete = new google.maps.places.Autocomplete(search_input, options);
    //change values when autocomplete changes
    google.maps.event.addListener(search_autocomplete, 'place_changed', function() {
      getLatAndLng(this, address_id, lat_id, lng_id);
    });
    //create hidden fields where coordinates are stored
    if ($("#" + lat_id).length == 0) { //just do it once (fix turbolinks problem)
      if (model != "") {
        $(search_input).after("<input type='hidden' name=" + model + "[" + lat_name + "] id=" + lat_id + " value=" + (search_input.getAttribute('lat') || "") + ">" + "<input type='hidden' name=" + model + "[" + lng_name + "] id=" + lng_id + " value=" + (search_input.getAttribute('lng') || "") + ">" + "<input type='hidden' name=" + model + "[" + address_name + "] id=" + address_id + " value ='" + (search_input.getAttribute('address_name') || "") + "'>");
      } else {
        $(search_input).after("<input type='hidden' name=" + lat_name + " id=" + lat_id + " value=" + (search_input.getAttribute('lat') || "") + ">" + "<input type='hidden' name=" + lng_name + " id=" + lng_id + " value=" + (search_input.getAttribute('lng') || "") + ">" + "<input type='hidden' name=" + address_name + " id=" + address_id + " value ='" + (search_input.getAttribute('address_name') || "") + "'>");
      }
    }
    window.id_sufix++; //prevents same ids on different autocomplete inputs
    //init map if id given
    if (map_id != "") {
      var map = new google.maps.Map(document.getElementById(map_id), {
        center: {
          lat: 19.432608,
          lng: -99.133209
        },
        zoom: 2,
      });
      //change map when autocomplete changes
      search_autocomplete.addListener('place_changed', function() {
        updateMap(this, search_input, map);
      });
    }
    //extra events
    if (send_on_select) {
      search_autocomplete.addListener('place_changed', function() {
        $(search_input).closest("form").find("input[type='submit']").click();
      });
      //erase value lat and lng if nothing was selected before send form
      $(search_input).on("keydown", function(e) {
        if (e.keyCode == 13 && !search_input.value) {
          document.getElementById(lat_id).value = "";
          document.getElementById(lng_id).value = "";
        }
      });

    }
  }); //end of waitForElement
}


//HELP FUNCTIONS
function updateMap(autocomplete, input, map) {
  place = autocomplete.getPlace();
  if (place.geometry) {
    map.panTo(place.geometry.location);
    map.setZoom(14);
  } else {
    input.value = '';
  }
}

function getLatAndLng(autocomplete, address_name_id, lat_name_id, lng_name_id) {
  place = autocomplete.getPlace();
  document.getElementById(address_name_id).value = place.formatted_address;
  document.getElementById(lat_name_id).value = place.geometry.location.lat();
  document.getElementById(lng_name_id).value = place.geometry.location.lng();
}
