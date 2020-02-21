$(document).on('turbolinks:load', function() {
  $('form#search-form').change(function() {
    $(this).closest('form').submit();
  });
});
