document.addEventListener("turbolinks:load", function() {
  $.validator.messages.required = '';
   $(".search-form").validate();
 });
