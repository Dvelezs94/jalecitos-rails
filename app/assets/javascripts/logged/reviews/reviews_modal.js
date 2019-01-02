$(document).on('turbolinks:load', function() {
  //if query string review is present and there is a review pending...
  if (window.location.href.indexOf("?review=") > -1 && $("#reviewModal").length > 0) {
    modals('reviewModal', "closeReview", "none", true );
  }
});
