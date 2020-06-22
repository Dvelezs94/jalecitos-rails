$(document).on('turbolinks:load', function() {
  $(".send-on-change").change( function(){
    $(this).find("[type=submit]").click();
  });
});
