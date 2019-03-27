function updateURL(name, value, focusAfterReload="") { //removes all other query string and puts the new specified
  if (history.pushState) {
    if (focusAfterReload=="") {
      var newurl = window.location.protocol + "//" + window.location.host + window.location.pathname + '?'+name+'='+value;
    }
    else { //focus something after change location reload
      var newurl = window.location.protocol + "//" + window.location.host + window.location.pathname + '?'+name+'='+value+'&focusAfterReload='+focusAfterReload;
    }
      window.history.pushState({path:newurl},'',newurl);
  }
}

function updateConvURL(name, value) { //removes all other query string and puts the new specified

  if (history.pushState) {
      var newurl = window.location.protocol + "//" + window.location.host + window.location.pathname + "?user_id="+$.getUrlVar("user_id")+"&"+name+'='+value;
      window.history.pushState({path:newurl},'',newurl);
  }
}
