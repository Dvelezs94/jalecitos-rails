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
    // add to flash notifications and display
    $("[flash-notifications]").prepend(data.fadeItem);
    $("[flash-notifications] .toast").toast("show");
    //add that notification to the list
    $("[notifications]").after(data.listItem);
    if ($("[notification]").length > 5){
      $("[notification]:last").remove();
    }

    //if a review modal is recieved and the user doesnt have displayed other
    if(data.reviewItem && $("#reviewModal").length == 0){
      $("body").prepend(data.reviewItem); // gets the modal
      modals('rev-modal', 'reviewModal', "closeReview", "none", true ); //shows the modal
      activate_ratyrate(); //activates stars
      review_validation(); //activates the validation of the form
    }
    //put the red dot
    $("[read-notifications] span").removeClass("d-none");
  }
});
