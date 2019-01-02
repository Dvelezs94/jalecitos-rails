$(document).on('turbolinks:load', function() {
  if (window.location.href.indexOf("configuration") > -1) {
    modals('cardModal', "cardbtn");
    modals('bankModal', "bankbtn");
    modals('changePasswordModal', "changepassbtn");
  }
});
