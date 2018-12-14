function ajaxSent(){
  //need one more response
  window.sentImages +=1;
  //change style of continue if an ajax is sent
  if( $("#continue-process").css("cursor") == "pointer" ){
    $("#continue-process")[0].style.cursor = "auto";
    $("#continue-process")[0].style.backgroundColor = "gray";
    $("#continue-process")[0].style.border = "gray";
  }
}
function ajaxRecieved(){
  //got one more response
  window.sentImages -=1;
  //change to normal style of continue if all ajax recieved
  if( window.sentImages == 0 ){
    $("#continue-process")[0].style.cursor = "pointer";
    $("#continue-process")[0].style.backgroundColor = "#28a745";
    $("#continue-process")[0].style.border = "#28a745";
  }
}
