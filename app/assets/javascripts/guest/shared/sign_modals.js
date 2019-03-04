$(document).on('turbolinks:load', function() {
  if ($('#inModal').length > 0) {
  modals('inModal', "sign_in");
  modals('upModal', "sign_up");
  modals('upModal', "register");

  //when resizing on 767 the events doesnt exist because of the menu
  $(window).resize(function() {
      modals('inModal', "sign_in");
      modals('upModal', "sign_up");
      modals('upModal', "register");
  });
}
});
