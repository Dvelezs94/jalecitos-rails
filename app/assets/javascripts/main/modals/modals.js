function modals (modalName, modalId, buttonId, buttonBehaviour="block", display=false) {
  // Get the modal
  var modal = document.getElementById(modalId);
  //display if necessary
  //by value in function...
  if (display == true){
    modal.style.display = "block";
  }
  //by query string...
  if ($.getUrlVar("modal") == modalName) {
    modal.style.display = "block";
  }
  // Get the button that closes
  var button = document.getElementById(buttonId);

  // When the user clicks the button, open or close the modal and also closes all other modals (useful when the button behaviour is display the modal)
  button.onclick = function(event) {
    event.preventDefault();
    modal.style.display = buttonBehaviour;
    closeOtherModals(modalId);
    closeMenu();
  }
  // When the user clicks anywhere outside of the modal, close it
  modal.onclick = function(event) {
    //yo can click also childs of modal, so...
    if (event.target == modal){
      modal.style.display = "none";
    }
  }
}

function closeOtherModals(modalId){
  //closes the other modals
  for (var i = 0; i < $(".modal").length; i++) {
    if ( $(".modal")[i].id != modalId ){
      $(".modal")[i].style.display = "none";
    }
  }
}

function closeMenu() {
  $(".meanclose").click();
}
