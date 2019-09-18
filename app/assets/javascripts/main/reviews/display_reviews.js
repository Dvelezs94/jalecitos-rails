function display_reviews(strict=false) { //if strict, i want that modal just open, if its open, stay that way
  //just in mobiles
  if ($( window ).width() < 768 ){
    if ( strict || $('.servicoteam-wrap').css('display') == 'none' ) {
      $('.servicoteam-wrap').slideDown();
      $('.reviews_dropdown').removeClass('fa-angle-down').addClass('fa-angle-up');
    }
    else {
      $('.servicoteam-wrap').slideUp();
      $('.reviews_dropdown').removeClass('fa-angle-up').addClass('fa-angle-down');
    }
  }
}
