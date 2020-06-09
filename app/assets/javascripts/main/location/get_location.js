//incomplete because it doesnt work (tested in ngrok), but also i need to change address_name and currently i done know how to

// function getLocation() {
//   if (navigator.geolocation) {
//     setTimeout(function(){
//       navigator.geolocation.getCurrentPosition(showPosition, showError);
//     }, 2000);
//   } else {
//     console.log("Geolocation is not supported by this browser.");
//   }
// }
//
// function showPosition(position) {
//   console.log("jajaja")
//   if ($("#sign_up_lat").length > 0) {
//     $("#sign_up_lat").val(position.coords.latitude);
//     $("#sign_up_lon").val(position.coords.longitude);
//     $(".facebook-login").each(function(){
//       var oldUrl = $(this).attr("action"); // Get current url
//       var newLat = oldUrl.replace("latitude", position.coords.latitude); // Create new url
//       var newLon = newLat.replace("longitude", position.coords.longitude); // Create new url
//       $(this).attr("action", newLon);
//     });
//   }
//   if ($("#lat").length > 0) {
//     $("#lat").val(position.coords.latitude);
//     $("#lon").val(position.coords.longitude);
//   }
// }
//
// function showError(error) {
//   switch(error.code) {
//     case error.PERMISSION_DENIED:
//       console.log("User denied the request for Geolocation.");
//       break;
//     case error.POSITION_UNAVAILABLE:
//       console.log("Location information is unavailable.");
//       break;
//     case error.TIMEOUT:
//       console.log("The request to get user location timed out.");
//       break;
//     case error.UNKNOWN_ERROR:
//       console.log("An unknown error occurred.");
//       break;
//   }
// }
