$(document).on('turbolinks:load', function() {
  $(".banner-search").validate({
    messages : {
      "query" :{
        required: ""
      }
    }
  });
 });
