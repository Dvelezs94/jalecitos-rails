$(document).on('turbolinks:load', function() {
    modals('create-opy-acc','createOpenpayAccountModal', "create-openpay-user");
    modals('charge-opy-acc','chargeOpenpayAccountModal', "charge-openpay-user");
    modals('createBan','createBan', "createABan", "block", false, true);
});
