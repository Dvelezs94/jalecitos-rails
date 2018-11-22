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

function textColor(length, id, number) {
  if (id == "#count_D_" && length <= 1000) {
    $( id + number)[0].style.color = "green";
  }
  else if (id == "#count_D_" && length > 1000){
    $(id + number)[0].style.color = "red";
  }
  else if (id == "#count_N_" && length <= 100){
    $(id + number)[0].style.color = "green";
  }
  else{
    $(id + number)[0].style.color = "red";
  }
}
