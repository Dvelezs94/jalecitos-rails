$(document).on('turbolinks:before-cache', function() {
  window.cached = true;
  //if cached, then no messages (all have been read)
  $("#new_message").val(false);
  //remove modals
  $(".modal").css("display", "none");
});

$(document).on('turbolinks:load', function() {
  window.tries_count = 0;
  var checkExist = setInterval(function() {
    if ($('#gritter-notice-wrapper').length) { // cached gritter or maybe not (#new_message tell us)
      if (window.cached && $("#new_message").val() != "true") { // if page is cached and not new_notice, dont show gritter again (gritter will show just a few milliseconds)
        $("#gritter-notice-wrapper").addClass("hidden");
      }
      clearInterval(checkExist);
    }
    else{
      window.tries_count += 1;
    }
    if (window.tries_count == 100) { //if no notification, this will run always
      clearInterval(checkExist);
    }
  }, 10)
});
