$(document).on('turbolinks:load', function() {
  $('form#search-form').change(function(event) {
    //dont send form when location changes and not select one
    if (event.target.id != "search_autocomplete") $("#search-form-submit").click();
  });
  $( "#search-form-submit" ).on("click", function(event) {
    $("#searchList").addClass("invisible");
    $("#loading-results").removeClass("d-none");
    $("#results-text").html("Cargando...");
  });
});
