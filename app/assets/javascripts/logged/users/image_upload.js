$(document).on('turbolinks:load', function() {
  /* Activating Best In Place */
  if ($(".profile-container")) {
    $('#user_image').fileupload();
  }
});
