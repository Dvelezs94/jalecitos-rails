$(document).on('turbolinks:load', function() {
  if ($(".gig_header")) {
    // Get the modal
    var reportGigModal = document.getElementById('reportGigModal');

    // Get the button that opens the modal
    var reportGigBtn = document.getElementById("reportgigbtn");


    // When the user clicks the button, open the modal
    reportGigBtn.onclick = function() {
      reportGigModal.style.display = "block";
    }


    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function(event) {
      if (event.target == reportGigModal) {
        reportGigModal.style.display = "none";
      }
    }
  }
});
