// Help functions for user google input in my_profile
function sleep(milliseconds) {
  var start = new Date().getTime();
  for (var i = 0; i < 1e7; i++) {
    if ((new Date().getTime() - start) > milliseconds) {
      break;
    }
  }
}
function waitForElement(elementPath, callBack) {
  window.setTimeout(function() {
    if ($(elementPath).length) {
      callBack(elementPath, $(elementPath));
    } else {
      waitForElement(elementPath, callBack);
    }
  }, 500)
}
function openCity(evt, cityName) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
    document.getElementById(cityName).style.display = "block";
    evt.currentTarget.className += " active";
}
function textColor(length, id, number) {
  if (id == "#count_D_" && length <= 1000) {
    $( id + number)[0].style.color = "green";
  }
  else if (id == "#count_D_" && length > 1000){
    $(id + number)[0].style.color = "red";
  }
  else if (id == "#count_N_" && length <= 1000){
    $(id + number)[0].style.color = "green";
  }
  else if (id == "#count_N_" && length > 100){
    $(id + number)[0].style.color = "red";
  }
}
