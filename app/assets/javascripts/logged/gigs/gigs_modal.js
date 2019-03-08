$(document).on('turbolinks:load', function() {
  if ($("#reportgigbtn").length > 0 ) {
    modals('report_gig', 'reportGigModal', "reportgigbtn");
  }
});
