function scrollBottomMessages() {
  if ($("[content-scrolleable]").length > 0) {
    $("[content-scrolleable]").scrollTop($("[messages-list]")[0].scrollHeight);
  }
}

$(document).on('turbolinks:load', function() {
  window.tries_count_2 = 0
  var middle = screen.height * 0.75 //used to know if keyboard is shown
  scrollBottomMessages(); //at page load scroll down
  $("#message_body").focus(function() {
    if (screen.width <= 768) {
      //on focus wait for keyboard and scroll down
      var scrolldown = setInterval(function() {
        if (middle > $(window).height()) {
          scrollBottomMessages();
          clearInterval(scrolldown);
        } else {
          window.tries_count_2 += 1;
        }
        if (window.tries_count_2 == 5) { //prevent running for ever
          window.tries_count_2 = 0 //if its used again
          clearInterval(scrolldown);
        }
      }, 100)
    }
    else { //dont have to wait for keyboard to show up
      scrollBottomMessages();
    }
  });
  //also for click
  $("#message_body").click(function() {
    $("#message_body").focus();
  });
});
