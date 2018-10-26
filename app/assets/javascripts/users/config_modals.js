document.addEventListener("turbolinks:load", function() {
  // Get the modal
  var bankModal = document.getElementById('bankModal');
  var cardModal = document.getElementById('cardModal');

  // Get the button that opens the modal
  var bankBtn = document.getElementById("bankbtn");
  var cardBtn = document.getElementById("cardbtn");


  // When the user clicks the button, open the modal
  bankBtn.onclick = function() {
    bankModal.style.display = "block";
    cardModal.style.display = "none";
  }

  cardBtn.onclick = function() {
    cardModal.style.display = "block";
    bankModal.style.display = "none";
  }

  // When the user clicks anywhere outside of the modal, close it
  window.onclick = function(event) {
    if (event.target == bankModal || event.target == cardModal) {
      bankModal.style.display = "none";
      cardModal.style.display = "none";
    }
  }
});
