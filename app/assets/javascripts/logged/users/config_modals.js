$(document).on('turbolinks:load', function() {
  if (window.location.href.indexOf("configuration") > -1) {
    // Get the modal
    var bankModal = document.getElementById('bankModal');
    var cardModal = document.getElementById('cardModal');
    var changePasswordModal = document.getElementById('changePasswordModal');
    var billingProfiledModal = document.getElementById('billingProfileModal');

    // Get the button that opens the modal
    var bankBtn = document.getElementById("bankbtn");
    var cardBtn = document.getElementById("cardbtn");
    var changePasswordBtn = document.getElementById("changepassbtn");
    var billingProfileBtn = document.getElementById("billingprofilebtn");


    // When the user clicks the button, open the modal
    bankBtn.onclick = function() {
      bankModal.style.display = "block";
      cardModal.style.display = "none";
      changePasswordModal.style.display = "none";
      billingProfiledModal.style.display =  "none";
    }

    cardBtn.onclick = function() {
      cardModal.style.display = "block";
      bankModal.style.display = "none";
      changePasswordModal.style.display = "none";
      billingProfiledModal.style.display =  "none";
    }

    changePasswordBtn.onclick = function() {
      changePasswordModal.style.display = "block";
      cardModal.style.display = "none";
      bankModal.style.display = "none";
      billingProfiledModal.style.display =  "none";
    }

    billingProfileBtn.onclick = function() {
      changePasswordModal.style.display = "none";
      cardModal.style.display = "none";
      bankModal.style.display = "none";
      billingProfiledModal.style.display =  "block";
    }

    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function(event) {
      if (event.target == bankModal || event.target == cardModal || event.target == changePasswordModal ||  event.target == billingProfileModal) {
        bankModal.style.display = "none";
        cardModal.style.display = "none";
        changePasswordModal.style.display = "none";
        billingProfiledModal.style.display =  "none";
      }
    }
  }
});
