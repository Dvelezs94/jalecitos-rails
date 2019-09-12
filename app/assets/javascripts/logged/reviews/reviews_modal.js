$(document).on('turbolinks:load', function() {
  //if there is a review pending...
    modals('review', 'reviewModal', "closeReview", "none", true );
    modals('recommendation', 'recommendationModal', "closeRecommendation", "none", false );
});
