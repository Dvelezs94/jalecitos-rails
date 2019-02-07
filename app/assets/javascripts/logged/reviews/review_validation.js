function review_validation () {
  $(".review_form").validate({
    ignore: "", // this allows score (hidden field) get validated
    rules : {
     'score' : {
         required: true
     }
   },
   messages: {
     'score' : {
       required : "Debes dar una valoración"
     }
   }
 });
}
