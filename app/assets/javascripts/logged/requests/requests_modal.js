$(document).on('turbolinks:load', function() {
  if ($("#reportrequestbtn").length > 0) {
    // Get the modal
    var reportRequestModal = document.getElementById('reportRequestModal');

    // Get the button that opens the modal
    var reportRequestBtn = document.getElementById("reportrequestbtn");


    // When the user clicks the button, open the modal
    reportRequestBtn.onclick = function() {
      reportRequestModal.style.display = "block";
    }


    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function(event) {
      if (event.target == reportRequestModal) {
        reportRequestModal.style.display = "none";
      }
    }
  }
});
