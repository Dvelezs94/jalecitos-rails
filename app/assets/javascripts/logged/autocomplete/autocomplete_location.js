$(document).on('turbolinks:load', function() {

  $('#mobile_menu_autocomplete').typeahead(null, {
    source: window.autocomplete_location
  }).on('typeahead:selected', function(e, data) {
    $(event.target).closest("form").submit();
    //keep variable so the event of keyup knows that there is no error because the enter submitted an option
    window.form_submitted = true;
  });
  $('#search_autocomplete').typeahead(null, {
    source: window.autocomplete_location
  });


  $('#form_autocomplete').typeahead(null, {
    source: window.autocomplete_location
  });
});
