function modals (modalName, modalId, buttonIdOrClass, buttonBehaviour="block", display=false, buttonIsClass=false) {
  // Get the modal
  var modal = document.getElementById(modalId);
  // Get the button that closes
  if (buttonIsClass == false) { //id of button given
    var button = $("#" + buttonIdOrClass);
  }
  else { //class of button given (maybe a lot of buttons open a modal)
    var button = $("." + buttonIdOrClass);
  }
  //make all if both exist
  if ( modal != null && button != null ) {
    //display if necessary
    //by value in function...
    if (display == true){
      modal.style.display = "block";
    }
    //by query string...
    if ($.getUrlVar("modal") == modalName) {
      modal.style.display = "block";
    }

    // When the user clicks anywhere outside of the modal, close it
    modal.onclick = function(event) {
      //yo can click also childs of modal, so...
      if (event.target == modal){
        modal.style.display = "none";
      }
    }
  }
  // When the user clicks the button, open or close the modal and also closes all other modals (useful when the button behaviour is display the modal)
  $(document).on("click", (buttonIsClass == false)? "#"+buttonIdOrClass : "."+buttonIdOrClass, function(event) {
    event.preventDefault();
    if(modal != null ) modal.style.display = buttonBehaviour;
    closeOtherModals(modalId);
  });
}

function closeOtherModals(modalId){
  //closes the other modals
  for (var i = 0; i < $(".modal").length; i++) {
    if ( $(".modal")[i].id != modalId ){
      $(".modal")[i].style.display = "none";
    }
  }
}
