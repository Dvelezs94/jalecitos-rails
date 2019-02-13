$(document).on('turbolinks:load', function() {
  if ($("#contactbtn").length > 0) {
    modals('contactModal',"contactbtn");
    modals('contactModal',"contact2btn");
  }
});
