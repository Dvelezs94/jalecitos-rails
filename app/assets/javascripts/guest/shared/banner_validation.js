$(document).on('turbolinks:load', function() {
  $.validator.messages.required = '';
  $(".banner-search").validate();
 });
