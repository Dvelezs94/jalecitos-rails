$(document).on('turbolinks:load', function() {
  if ($("#reportuserbtn").length > 0) {
     modals('reportUserModal', "reportuserbtntablet" );
     modals('reportUserModal', "reportuserbtn" );
  }
});
