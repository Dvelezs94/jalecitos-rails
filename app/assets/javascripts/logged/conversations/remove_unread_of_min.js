$(document).on('turbolinks:load', function() {
  //removes unread dot from conv min when clicked
  $("[contacts-list]").on("click", "a[data-user-id]",function(){
    $(this).find("span").remove();
  });
});
