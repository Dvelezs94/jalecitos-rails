$(document).on('turbolinks:load', function() {
  if($(".ban_form").length > 0){
   $(".ban_form").validate();
  }
});
