function move_to_element(element){
  $('html, body').animate({
    scrollTop: ($(element).offset().top-200)
  }, 1000);
}
