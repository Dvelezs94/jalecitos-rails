$(document).on('turbolinks:load', function() {
  if ($("#reportgigbtn").length > 0 ) {
    modals('reportGigModal', "reportgigbtn");
  }
});
