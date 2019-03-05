App.notifications = App.cable.subscriptions.create("NotificationsChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    //parse all the recieved data
    data = JSON.parse(data.html);
    // Called when there's incoming data on the websocket for this channel
    $("#notifications").prepend(data.fadeItem);
    //add that notification to the list
    $(".notification-items").prepend(data.listItem);

    //if a review modal is recieved and the user doesnt have displayed other
    if(data.reviewItem && $("#reviewModal").length == 0){
      $("body").prepend(data.reviewItem); // gets the modal
      modals('reviewModal', "closeReview", "none", true ); //shows the modal
      activate_ratyrate(); //activates stars
      review_validation(); //activates the validation of the form
    }
    //put the red dot
    $(".notif-icon").addClass("unread");
    //then hide and remove notification
    $("#notifications .toast__container").last().delay(5000).hide(1500, function(){ $("#notifications .toast__container").last().remove(); });
  }
});
