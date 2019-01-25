function getLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition, showError);
  } else {
    x.innerHTML = "Geolocation is not supported by this browser.";
  }
}

function showPosition(position) {
  if ($("#sign_up_lat").length > 0) {
    console.log(position.coords.latitude, position.coords.longitude);
    $("#sign_up_lat").val(position.coords.latitude);
    $("#sign_up_lon").val(position.coords.longitude);
    $(".loginBtn--facebook").each(function(){
      var oldUrl = $(this).attr("href"); // Get current url
      var newLat = oldUrl.replace("latitude", position.coords.latitude); // Create new url
      var newLon = newLat.replace("longitude", position.coords.longitude); // Create new url
      $(this).attr("href", newLon)
    });
  }
}

function showError(error) {
  switch(error.code) {
    case error.PERMISSION_DENIED:
      console.log("User denied the request for Geolocation.");
      break;
    case error.POSITION_UNAVAILABLE:
      console.log("Location information is unavailable.");
      break;
    case error.TIMEOUT:
      console.log("The request to get user location timed out.");
      break;
    case error.UNKNOWN_ERROR:
      console.log("An unknown error occurred.");
      break;
  }
}
