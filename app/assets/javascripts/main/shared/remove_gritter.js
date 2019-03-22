$(document).on('turbolinks:before-cache', function() {
  window.cached = true;
});

$(document).on('turbolinks:load', function() {
  window.tries_count = 0;
  if (window.cached) { // if page is cached, dont show gritter again (gritter will show just a fer milliseconds)
    var checkExist = setInterval(function() {
      if ($('#gritter-notice-wrapper').length) {
        $("#gritter-notice-wrapper").addClass("hidden");
        clearInterval(checkExist);
      }
      else{
        window.tries_count += 1;
      }
      if (window.tries_count == 100) { //if no notification, this will run always
        clearInterval(checkExist);
      }
    }, 10)
  }
});
