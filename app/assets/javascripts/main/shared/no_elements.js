$(document).on('turbolinks:load', function() {
  //used in homepage (also has effect in search)
  if( $(".no_gigs").length > 0 && $(".swiper-container-initialized").length == 0 && $(".single-gig").length == 0) {
    $("#nogigmess").removeClass("hidden");
  }
});
