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
  if($(".new_billing_profile").length > 0){
   $(".new_billing_profile").validate();
  }
  if($(".new_billing_profile").length > 0){
   $(".new_billing_profile").validate();
  }
  if($(".search-form-guest").length > 0){
   $(".search-form-guest").validate();
  }
});
