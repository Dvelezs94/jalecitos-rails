$(document).on('turbolinks:load', function() {
  stylize_notifications();
});

function stylize_notifications() {
  //remove dates
  days = $("[paginated-notif] [day]");

  for (var i = 1; i < days.length; i++) {
    currDay = days[i];
    prevDay = days[i - 1];
    if (currDay.innerHTML == prevDay.innerHTML) {
      $(currDay).remove();
    }
  }
}
