$(document).on('turbolinks:before-cache', function() {
  window.cached = true;
});

$(document).on('turbolinks:load', function() {
  if(window.cached) { // if page is cached, dont show gritter again
    $("#gritter-notice-wrapper").addClass("hidden");
  }
});
