$(document).on('turbolinks:load', function() {
  var prevScrollpos = window.pageYOffset;
  window.onscroll = function() {
    var currentScrollPos = window.pageYOffset;
    if (prevScrollpos >= currentScrollPos) {
      document.getElementById("main_menu").style.top = "0";
    } else {
      document.getElementById("main_menu").style.top = "-150px";
    }
    prevScrollpos = currentScrollPos;
  }
});
