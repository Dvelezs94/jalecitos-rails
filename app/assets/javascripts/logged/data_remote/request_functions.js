function ajaxSent(){
  var links = $(".clearfix li");
  //need one more response
  window.sentRequests +=1;
  //change style of buttons
  links.addClass("isDisabled");
  //show loading
  if($("div.loading").length > 1){
    //when there is more than one loading gif, loading zones are used to find the closest one
    $(window.target).closest("div.loading-zone").find("div.loading").show();
  }
  else{
    $("div.loading").show();
  }
}
function ajaxRecieved(){
  var links = $(".clearfix li");
  //got one more response
  window.sentRequests -=1;
  //change to normal style of continue if galleries and all ajax recieved
  if( window.sentRequests == 0 ){
    links.removeClass("isDisabled");
  }
  //if all responses recieved, hide loading
  if(window.sentRequests == 0){
    if($("div.loading").length > 1){
      //when there is more than one loading gif, loading zones are used to find the closest one
      $(window.target).closest("div.loading-zone").find("div.loading").hide();
    }
    else{
      $("div.loading").hide();
    }
  }
}
