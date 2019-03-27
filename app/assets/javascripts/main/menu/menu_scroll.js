$(document).on('turbolinks:load', function() {
  var prevScrollpos = window.pageYOffset;
  // dont move nav bar on ios
  if ( ! isIos()) {
    // dont move nav bar when wizard is up
    if (!(window.location.pathname == "/wizard")) {
      window.onscroll = function() {
        var currentScrollPos = window.pageYOffset;
        if (prevScrollpos >= currentScrollPos) {
          document.getElementById("main_menu").style.top = "0";
        } else {
          document.getElementById("main_menu").style.top = "-150px";
        }
        prevScrollpos = currentScrollPos;
      }
    }
   }
});
