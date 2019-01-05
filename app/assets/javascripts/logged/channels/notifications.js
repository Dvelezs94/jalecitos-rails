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

    //if a review modal is recieved
    if(data.reviewItem){
      $("body").append(data.reviewItem);
      modals('reviewModal', "closeReview", "none", true );
      activate_ratyrate();
      $(".review_form").validate({
        ignore: "", // this allows score (hidden field) get validated
        rules : {
         'score' : {
             required: true
         }
       },
       messages: {
         'score' : {
           required : "Debes dar una calificación"
         }
       }
     });
    }
    //add 1 count to notifications
    $("#unread-count").html( parseInt($("#unread-count").text())+1)
    //then hide and remove notification
    $("#notifications .toast__container").last().delay(5000).hide(1500, function(){ $("#notifications .toast__container").last().remove(); });
  }
});
