$(document).on('turbolinks:load', function() {
  if ($("[contacts-list] [data-user-id]").length > 0) {
    conv_min = $("[data-user-id="+$.getUrlVar("user_id")+"]");
    conv_min = $("[data-user-id="+$.getUrlVar("user_id")+"]").click(); //this doesnt trigger conversation ajax, to trigger it i need to do click() with js object
    conv_min.find("span").remove(); //removes red dot (when comes from notifications, need to remove red dot)
    $("#chatContentClose").on("click", function(){ //this removes user_id so if the user reloads the page in conv list, doesnt return to first conversation
      updateURL([],[]);
    });
  }
});
