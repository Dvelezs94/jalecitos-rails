$(document).on('turbolinks:load', function() {
  $(".mobile-google-span").click(function() {
    $(".mobile-location-item").css("display", "none");
    activateMobileSearch();
  });
});
