$(document).on('turbolinks:load', function() {
  if (window.location.href.indexOf("configuration") > -1) {
    modals('cardModal', "cardbtn");
    modals('bankModal', "bankbtn");
    modals('changePasswordModal', "changepassbtn");
    modals('billingProfileModal', "billingprofilebtn");
    // buttons for mobile
    modals('cardModal', "cardbtn2");
    modals('bankModal', "bankbtn2");
    modals('changePasswordModal', "changepassbtn2");
    modals('billingProfileModal', "billingprofilebtn2");
  }
});
