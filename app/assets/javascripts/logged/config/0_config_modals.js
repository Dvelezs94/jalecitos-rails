$(document).on('turbolinks:load', function() {
  if (window.location.href.indexOf("configuration") > -1) {
    modals('card', 'cardModal', "cardbtn2");
    modals('bank', 'bankModal', "bankbtn2");
    modals('change_password', 'changePasswordModal', "changepassbtn2");
    modals('billing', 'billingProfileModal', "billingprofilebtn2");
    modals('confirm_deletion', 'confirmAccountDeletionModal', "confirmaccountdeletionbtn");
  }
});
