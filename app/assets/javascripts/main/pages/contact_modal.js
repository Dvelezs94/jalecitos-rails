$(document).on('turbolinks:load', function() {
  if ($("#contactbtn").length > 0) {
    modals('contact', 'contactModal',"contactbtn");
    modals('contact', 'contactModal',"contact2btn");
  }
});
