document.addEventListener("turbolinks:load", function() {
$('*[data-link]').on("click",function(){
  window.location = $(this).data('link');
  return false;
});
});
