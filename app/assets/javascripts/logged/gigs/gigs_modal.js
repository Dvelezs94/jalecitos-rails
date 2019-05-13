$(document).on('turbolinks:load', function() {
  if ($(".reportgig").length > 0 ) {
    modals('report_gig', 'reportGigModal', "reportgigbtn");
  }
});
