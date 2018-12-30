$(document).on('turbolinks:load', function() {
  //if query string review is present and there is a review pending...
  if (window.location.href.indexOf("?review=") > -1 && $("#reviewModal").length > 0) {
    // Get the modal and display it
    var reviewModal = document.getElementById('reviewModal');
    reviewModal.style.display = "block";
    // // Get the button that closes
    // var closeButton = document.getElementById("reviewbtn");
    //
    //
    // // When the user clicks the button, open the modal
    // closeButton.onclick = function() {
    //   reviewModal.style.display = "block";
    // }
    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function(event) {
      if (event.target == reviewModal) {
        reviewModal.style.display = "none";
      }
    }
  }
});
