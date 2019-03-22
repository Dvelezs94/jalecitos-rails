$(document).on('turbolinks:load', function() {
  if ($('#inModal').length > 0) {
  modals('sign_in', 'inModal', "sign_in");
  modals('sign_up', 'upModal', "sign_up");
  modals('sign_up', 'upModal', "register");

  //when resizing on 767 the events doesnt exist because of the menu
  $(window).resize(function() {
    modals('sign_in', 'inModal', "sign_in");
    modals('sign_up', 'upModal', "sign_up");
    modals('sign_up', 'upModal', "register");
  });
}
if($('#ready_to').length > 0) {
  modals('sign_up', 'upModal', "ready_to");
}
if ( $("#nogigmess").length > 0 ) {
  modals('sign_up', 'upModal', "nogigmess");
}
});
