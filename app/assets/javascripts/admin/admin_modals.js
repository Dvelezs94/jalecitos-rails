$(document).on('turbolinks:load', function() {
  if ($("#createOpenpayAccountModal").length > 0) {
    modals('create-opy-acc','createOpenpayAccountModal', "create-openpay-user");
  }
});
