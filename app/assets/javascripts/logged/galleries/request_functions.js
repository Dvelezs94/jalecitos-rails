function ajaxSent(){
  //need one more response
  window.sentImages +=1;
  //change style of continue if necessary...
  if($("#continue-process").css("cursor") == "pointer" ){
    $("#continue-process")[0].style.cursor = "auto";
    $("#continue-process")[0].style.backgroundColor = "gray";
    $("#continue-process")[0].style.border = "gray";
  }
}
function ajaxRecieved(){
  //got one more response
  window.sentImages -=1;
  //change style of continue if necessary...
  if($("#continue-process").css("cursor") == "auto" ){
    $("#continue-process")[0].style.cursor = "pointer";
    $("#continue-process")[0].style.backgroundColor = "#28a745";
    $("#continue-process")[0].style.border = "#28a745";
  }
}
