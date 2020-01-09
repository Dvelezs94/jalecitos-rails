$(document).on('turbolinks:load', function() {
  modals('sign_in', 'inModal', "sign_in", "block", false, true);
  modals('sign_up', 'upModal', "sign_up", "block", false, true);

  //when resizing on 767 the events doesnt exist because of the menu
  $(window).resize(function() {
    modals('sign_in', 'inModal', "sign_in", "block", false, true);
    modals('sign_up', 'upModal', "sign_up", "block", false, true);
  });
});
