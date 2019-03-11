$(document).on('turbolinks:load', function() {
  $(".use-trix").on("click", function(event) {
  event.preventDefault();
  $("trix-toolbar").css("display", "block");
  $(".use-trix").css("display", "none");
});
});
