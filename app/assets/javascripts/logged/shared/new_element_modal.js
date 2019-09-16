$(document).on('turbolinks:load turbolinks:render', function() {
    modals('new_element', 'newElementModal', "newelementbtndesktop");
    modals('new_element', 'newElementModal', "newelementmodalphonetablet");
    modals('new_gig', 'newElementModal', "nogigmess");
    modals("", "", "closeModals", "none", false, true);

});
