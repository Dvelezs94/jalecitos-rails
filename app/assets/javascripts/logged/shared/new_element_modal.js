$(document).on('turbolinks:load', function() {
    modals('new_element', 'newElementModal', "newelementbtndesktop");
    modals('new_element', 'newElementModal', "newelementmodalphonetablet");
    if ( $("#nogigmess").length > 0 ) {
      modals('new_gig', 'newElementModal', "nogigmess");
    }

});
