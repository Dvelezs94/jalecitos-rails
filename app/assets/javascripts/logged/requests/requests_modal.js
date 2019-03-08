$(document).on('turbolinks:load', function() {
  if ($("#reportrequestbtn").length > 0) {
    modals('report_request', 'reportRequestModal',"reportrequestbtn");
  }
});
