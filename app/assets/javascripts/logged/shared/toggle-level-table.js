$(document).on('turbolinks:load', function() {
  $(".level-toggler").on("click", function() {
    event.preventDefault();
    number = $(this).attr("class").split(" ")[1][2];
    $(".level-table-"+ number).toggleClass("hidden");
  });
});
