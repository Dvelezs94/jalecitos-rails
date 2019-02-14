$(document).on('turbolinks:load', function() {
  if ($(".menu-location-span").length > 0) {
    $(".menu-location-span").click(function() {
      $(".mobile-location-item").css("display", "none");
      mobileMenuAutocomplete();
    });
  }
});

function mobileMenuAutocomplete() {
  waitForElement(".mobile_menu_autocomplete", function() {
    $('.mobile_menu_autocomplete').typeahead(null, {
      source: window.autocomplete_search
    });
  });
}
