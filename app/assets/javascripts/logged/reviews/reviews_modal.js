$(document).on('turbolinks:load', function() {
  //if there is a review pending...
  if ( $("#reviewModal").length > 0) {
    modals('review', 'reviewModal', "closeReview", "none", true );
  }
});
