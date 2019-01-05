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
    $(".review_form").validate({
      ignore: "", // this allows score (hidden field) get validated
      rules : {
       'score' : {
           required: true
       }
     },
     messages: {
       'score' : {
         required : "Debes dar una calificación"
       }
     }
   });
  }
});
