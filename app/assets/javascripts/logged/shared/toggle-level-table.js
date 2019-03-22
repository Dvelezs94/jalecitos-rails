$(document).on('turbolinks:load', function() {
  $(".level-toggler").on("click", function() {
    event.preventDefault();
    number = $(this).attr("class").split(" ")[1][2];
    $(this).addClass("hidden");
    $(".lt-"+ number).removeClass("hidden");
  });

  $(".level-table").on("click", function() {
    event.preventDefault();
    number = $(this).attr("class").split(" ")[1][3];
    $(this).addClass("hidden");
    $(".t-"+ number).removeClass("hidden");
  });
});
