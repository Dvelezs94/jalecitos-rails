document.addEventListener("turbolinks:load", function() {
  // Get the modal
  var modal1 = document.getElementById('inModal');
  var modal2 = document.getElementById('upModal');

  // Get the button that opens the modal
  var btn1 = document.getElementById("sign_in");
  var btn2 = document.getElementById("sign_up");
  //get element "registrate" sign in redirect to sign up
  var register = document.getElementById('register');

  // When the user clicks the button, open the modal
  btn1.onclick = function() {
    modal1.style.display = "block";
    modal2.style.display = "none";
  }
  btn2.onclick = function() {
    modal1.style.display = "none";
    modal2.style.display = "block";
  }
  //redirect from sign in to sign up with "registrate"


  // When the user clicks anywhere outside of the modal, close it
  window.onclick = function(event) {
    if (event.target == modal1 || event.target == modal2 ) {
      modal1.style.display = "none";
      modal2.style.display = "none";
    }
  }
});
