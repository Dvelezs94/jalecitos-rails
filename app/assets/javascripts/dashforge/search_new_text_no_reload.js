$(document).on('turbolinks:load', function() {
  $('#simple-query').submit(function() {
    filterInput =$("#query-filter");
    if (filterInput.length > 0) {
      event.preventDefault();
      input = $(this).find("#query");
      filterInput.val( input.val() );
      $("#search-form").change(); //this makes the query
      $("#navbarSearchClose").click(); // close search collapse
    }
  });
});
