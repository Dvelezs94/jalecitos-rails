$(document).on('turbolinks:load', function() {
  if (screen.width <= 991) {
    // text areas and inputs
    $('input').focusin(function() {
      $('.phone-bottom-menu').hide();
    });
    $('input').focusout(function() {
      $('.phone-bottom-menu').show();
    });
    $('textarea').focusin(function() {
      $('.phone-bottom-menu').hide();
    });
    $('textarea').focusout(function() {
      $('.phone-bottom-menu').show();
    });
    //  for best in place
    $('span.best_in_place').focusin(function() {
      $('.phone-bottom-menu').hide();
    });
    $('span.best_in_place').focusout(function() {
      $('.phone-bottom-menu').show();
    });
    //  for trix
    document.addEventListener("trix-focus", function(event) {
      $('.phone-bottom-menu').hide();
    });
    document.addEventListener("trix-blur", function(event) {
      $('.phone-bottom-menu').show();
    });
  }
});
