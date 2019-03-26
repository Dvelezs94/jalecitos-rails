$(document).on('turbolinks:load', function() {
  if ( $("#main_menu").length > 0 ) {    
    const isIos = () => {
      const userAgent = window.navigator.userAgent.toLowerCase();
      return /iphone|ipad|ipod/.test( userAgent );
    }
    var prevScrollpos = window.pageYOffset;
    if ( ! isIos()) {
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
