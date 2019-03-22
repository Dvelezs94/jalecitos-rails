$(document).on('turbolinks:before-cache', function() {
  window.cached = true;
});

$(document).on('turbolinks:load', function() {
  if (window.cached) { // if page is cached, dont show gritter again (gritter will show just a fer milliseconds)
    var checkExist = setInterval(function() {
      if ($('#gritter-notice-wrapper').length) {
        $("#gritter-notice-wrapper").addClass("hidden");
        clearInterval(checkExist);
      }
    }, 10)
  }
});
