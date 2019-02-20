$(document).on('turbolinks:load', function() {
  if (window.location.href.indexOf("configuration") > -1) {
    modals('cardModal', "cardbtn2");
    modals('bankModal', "bankbtn2");
    modals('changePasswordModal', "changepassbtn2");
    modals('billingProfileModal', "billingprofilebtn2");
    modals('confirmAccountDeletionModal', "confirmaccountdeletionbtn")
  }
});
