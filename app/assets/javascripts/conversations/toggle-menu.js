var isHidden = false;
 function toggleVisibility() {
    var menu = document.getElementById('menu');
    if(!isHidden){
      menu.style.opacity = "0";
      menu.style.visibility = "invisible";
    }else{
      menu.style.visibility = "visible";
      menu.style.opacity = "1";
    }
    isHidden = !isHidden;
}
