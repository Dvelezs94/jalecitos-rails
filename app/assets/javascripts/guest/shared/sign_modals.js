$(document).on('turbolinks:load', function() {
  if ($('#inModal').length > 0) {
  modals('sign_in', 'inModal', "sign_in");
  modals('sign_up', 'upModal', "sign_up");
  modals('sign_up', 'upModal', "register");
  modals('sign_up', 'upModal', "ready_to");

  //when resizing on 767 the events doesnt exist because of the menu
  $(window).resize(function() {
    modals('sign_in', 'inModal', "sign_in");
    modals('sign_up', 'upModal', "sign_up");
    modals('sign_up', 'upModal', "register");
  });
}
});
