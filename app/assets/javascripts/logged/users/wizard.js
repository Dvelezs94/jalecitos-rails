$(document).on('turbolinks:load', function() {
  if ($("#wizard").length > 0 ) {
   $("#wizard").steps();
  }
});
