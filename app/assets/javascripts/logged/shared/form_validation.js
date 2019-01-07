$(document).on('turbolinks:load', function() {
  if($(".current_form").length > 0){
   $(".current_form").validate();
  }
  if($(".new_card").length > 0){
   $(".new_card").validate();
  }
  if($(".new_bank").length > 0){
   $(".new_bank").validate();
  }
  if($(".review_form").length > 0){
    review_validation();
  }
});
