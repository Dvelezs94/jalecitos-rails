$(document).on('turbolinks:load', function() {
  if ($("#reportuserbtn").length > 0) {
    // Get the modal
    var reportUserModal = document.getElementById('reportUserModal');

    // Get the button that opens the modal
    var reportUserBtn = document.getElementById("reportuserbtn");


    // When the user clicks the button, open the modal
    reportUserBtn.onclick = function(e) {
      e.preventDefault();
      reportUserModal.style.display = "block";
    }


    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function(event) {
      if (event.target == reportUserModal) {
        reportUserModal.style.display = "none";
      }
    }
  }
});
