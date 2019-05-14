$(document).on('turbolinks:load', function() {
  modals('sign_in', 'inModal', "sign_in");
  modals('sign_up', 'upModal', "sign_up");
  modals('sign_up', 'upModal', "register");

  //when resizing on 767 the events doesnt exist because of the menu
  $(window).resize(function() {
    modals('sign_in', 'inModal', "sign_in");
    modals('sign_up', 'upModal', "sign_up");
    modals('sign_up', 'upModal', "register");
  });
  modals('sign_up', 'upModal', "ready_to");

  modals('sign_up', 'upModal', "nogigmess");

});
