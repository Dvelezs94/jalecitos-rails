$(document).on('turbolinks:load', function() {
  //deletes flash notification when hide (go to notifications/flash/notification)
  $(document).on('hidden.bs.toast', '.toast', function() {
    $(this).remove();
  });
});
