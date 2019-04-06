$(document).on('turbolinks:load', function() {
  var prevScrollpos = window.pageYOffset;
  var main_menu = document.getElementById("main_menu");
  // dont move nav bar on ios
  if ( ! isIos()) {
    // dont move nav bar when wizard is up
    if (!(window.location.pathname == "/wizard")) {
      window.onscroll = function() {
        var currentScrollPos = window.pageYOffset;
        if (prevScrollpos >= currentScrollPos) {
          main_menu.style.top = "0";
        } else {
          main_menu.style.top = "-"+main_menu.offsetHeight+"px";
          if ($(window).width() >= 992){ // if desktop and notifications is open, hide it
            $(".belldropdownarea.notification-items").removeClass("activee");
          }
        }
        prevScrollpos = currentScrollPos;
      }
    }
   }
});
