$(document).on('turbolinks:load', function() {
  if ($(".reportreq").length > 0) {
    modals('report_request', 'reportRequestModal',"reportrequestbtn");
  }
});
