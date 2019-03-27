$(document).on('turbolinks:load', function() {
  $("#edit_location").on("click", function(event) {
  event.preventDefault();
  $('#headingOne button.btn-link').click();
  $('html, body').animate({
    scrollTop: ($("#config_autocomplete").offset().top-200)
  }, 1000);
  updateURL("collapse", "notifications", "config_tags_input"); //send back to tags collapse on reload
  $('#config_autocomplete').focus();
  });
});
