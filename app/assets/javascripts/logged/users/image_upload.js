$(document).on('turbolinks:load', function() {
  /* Activating Best In Place */
  if ($(".profile-container")) {
     jQuery(".best_in_place").best_in_place();
    $('#user_image').fileupload();
  }
});