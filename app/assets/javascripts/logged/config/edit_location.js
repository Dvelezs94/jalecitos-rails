$(document).on('turbolinks:load', function() {
  $("#edit_location").on("click", function(event) {
  event.preventDefault();
  $('#headingOne button.btn-link').click();
  $('html, body').animate({
    scrollTop: $("#config_autocomplete").offset().top
  }, 1000);
  updateURL("collapse", "notifications", "config_tags_input"); //send back to tags collapse on reload
  $('#config_autocomplete').focus();
  });
});

function updateURL(name, value, focusAfterReload="") { //removes all other query string and puts the new specified
  if (history.pushState) {
    if (focusAfterReload=="") {
      var newurl = window.location.protocol + "//" + window.location.host + window.location.pathname + '?'+name+'='+value;
    }
    else { //focus something after change location reload
      var newurl = window.location.protocol + "//" + window.location.host + window.location.pathname + '?'+name+'='+value+'&focusAfterReload='+focusAfterReload;
    }
      window.history.pushState({path:newurl},'',newurl);
  }
}
