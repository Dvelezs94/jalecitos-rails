function updateURL(name, value, focusAfterReload="") { //removes all other query string and puts the new specified
  var strings = "";
  $.each(name, function( index, nam ) {
    strings += nam + "=" + value[index];
    if (index < name.length - 1) {
      strings += "&"
    }
  });
  if (focusAfterReload != "") { // if i want to focus something after reload (like tag in config)
    strings += "&focusAfterReload="+focusAfterReload
  }
  if (history.pushState) {
      var newurl = window.location.protocol + "//" + window.location.host + window.location.pathname + '?'+strings;
      window.history.pushState({path:newurl},'',newurl);
  }
}

function changeurl(url, title) {
    var new_url = url;
    window.history.pushState('data', 'Title', new_url.replace(/&amp;/g, '&'));
    if (title != "") document.title = title;
}
function updateFormURL(name, value) {
  var strings = "";
  //prepare all the query strings
  $.each(name, function( index, nam ) {
    strings += nam + "=" + value[index];
    if (index < name.length - 1) {
      strings += "&"
    }
  });
  forms = $(".wizard form");
  //append query strings to all forms
  $.each(forms, function( index, f ) {
    f.action = f.action.split("?")[0] + "?" + strings;
  });
}

function updateConvURL(name, value) { //removes all other query string and puts the new specified

  if (history.pushState) {
      var newurl = window.location.protocol + "//" + window.location.host + window.location.pathname + "?user_id="+$.getUrlVar("user_id")+"&"+name+'='+value;
      window.history.pushState({path:newurl},'',newurl);
  }
}
