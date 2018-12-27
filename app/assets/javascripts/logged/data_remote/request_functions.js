function ajaxSent(){
  //need one more response
  window.sentRequests +=1;
  //show loading
  $(".loading").show()
  //change style of continue if galleries
  if( $(".current_images").length > 0 && $("#continue-process").css("cursor") == "pointer" ){
    $("#continue-process")[0].style.cursor = "auto";
    $("#continue-process")[0].style.backgroundColor = "gray";
    $("#continue-process")[0].style.border = "gray";
  }
}
function ajaxRecieved(){
  //got one more response
  window.sentRequests -=1;
  //change to normal style of continue if galleries and all ajax recieved
  if( $(".current_images").length > 0 && window.sentRequests == 0 ){
    $("#continue-process")[0].style.cursor = "pointer";
    $("#continue-process")[0].style.backgroundColor = "#28a745";
    $("#continue-process")[0].style.border = "#28a745";
  }
  //if all responses recieved, hide loading
  if(window.sentRequests == 0){
    $(".loading").hide()
  }
}
