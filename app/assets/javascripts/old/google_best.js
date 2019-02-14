$(document).on('turbolinks:load', function() {
  if ($(".config-google-span").length > 0 ) {
    $(".config-google-span").click(function() {
      activateConfigSearch();
    });
  }
  if ($(".mobile-google-span").length > 0 ) {
    $(".mobile-google-span").click(function() {
      $(".mobile-location-item").css("display", "none");
      activateMobileSearch();
    });
  }
});
