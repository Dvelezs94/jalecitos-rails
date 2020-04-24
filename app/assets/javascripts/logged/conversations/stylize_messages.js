$(document).on('turbolinks:load', function() {
  stylize_messages();
});

function stylize_messages() {
  //remove dates
  days = $("[messages-list] [day]");

  for (var i = 1; i < days.length; i++) {
    currDay = days[i];
    prevDay = days[i - 1];
    if (currDay.innerHTML == prevDay.innerHTML) {
      $(currDay).addClass("d-none");
    }
  }
  // remove avatars (and message info)
  avatars = $("[messages-list] [avatar]");
  for (var i = 1; i < avatars.length; i++) {
    currItem = avatars[i];
    prevItem = avatars[i - 1];
    prevDay = days[i];
    if (currItem.getAttribute("avatar") == prevItem.getAttribute("avatar") && $(prevDay).hasClass("d-none") && min_diff( prevItem.getAttribute("date"), currItem.getAttribute("date") ) < 5 ) {
      $(currItem).addClass("invisible");
      currItem.style.height = "24px";
      $(currItem).closest("[message]").find("[msg-info]").addClass("d-none");
    } else {
      $(currItem).removeClass("invisible");
      $(currItem).closest("[message]").find("[msg-info]").removeClass("d-none");
      if ($(prevDay).hasClass("d-none")) $(currItem).closest("[message]").addClass("mg-t-20"); //give space to messages if no date before and other message up
    }
  }

}

function min_diff(startDate, endDate) {
  var startTime = new Date(startDate);
  var endTime = new Date(endDate);
  var difference = endTime.getTime() - startTime.getTime(); // This will give difference in milliseconds
  var resultInMinutes = Math.round(difference / 60000);
  return resultInMinutes
}
