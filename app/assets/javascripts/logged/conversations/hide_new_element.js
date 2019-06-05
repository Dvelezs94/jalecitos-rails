$(document).on('turbolinks:load', function() {
  //this is used in desktop because the plus button is in front of send message button
  if (window.location.href.indexOf("conversations") > -1) {
  $("#newelementbtndesktop").addClass("hidden");
  }
});
