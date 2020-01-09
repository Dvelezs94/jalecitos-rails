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
    $( id + number)[0].style.color = "#0067F3";
  }
  else if (id == "#count_D_" && length > 1000){
    $(id + number)[0].style.color = "red";
  }
  else if (id == "#count_N_" && length <= 100){
    $(id + number)[0].style.color = "#0067F3";
  }
  else{
    $(id + number)[0].style.color = "red";
  }
}
function share_content(elem, desk, text, confirmation, url){

  const canonicalElement = document.querySelector('link[rel=canonical]');

  if (canonicalElement !== null) {
    url = canonicalElement.href;
  }

  if (navigator.share) {
    navigator.share({
        title: document.title,
        text: desk,
        url: url
    })
  } else {
    new Clipboard(elem, {
      text: function() {
        return text;
      }
    });
    alert(confirmation);
  }
  event.preventDefault();
}
