$(document).on('turbolinks:load', function() {
  if ($("#reportuserbtn").length > 0) {
     modals('report_user', 'reportUserModal', "reportuserbtntablet" );
     modals('report_user', 'reportUserModal', "reportuserbtn" );
  }
});
