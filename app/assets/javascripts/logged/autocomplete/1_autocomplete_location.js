//number 1 because initializers have to go first
$(document).on('turbolinks:load', function() {

  $('#mobile_menu_autocomplete').typeahead(null, {
    source: window.autocomplete_location,
    displayKey: 'location',
    templates: {
      suggestion: function(data) {
        return '<p>' + data.location + '</p>';
      }
    }
  }).on('typeahead:selected', function(e, data) {
    window.location_val = $(this).val();
    $(event.target).closest("form").find(".city").val(data.id);
    $(event.target).closest("form").submit();
  }).on('typeahead:autocompleted', function(e, data) {
    window.location_val = $(this).val();
    $(event.target).closest("form").find(".city").val(data.id);
    $(event.target).closest("form").submit();
  });
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  $('#search_autocomplete').typeahead(null, {
    source: window.autocomplete_location,
    displayKey: 'location',
    templates: {
      suggestion: function(data) {
        return '<p>' + data.location + '</p>';
      }
    }
  }).on('typeahead:selected', function(e, data) {
    window.location_val = $(this).val();
    $(event.target).closest("form").find(".city").val(data.id);

  }).on('typeahead:autocompleted', function(e, data) {
    window.location_val = $(this).val();
    $(event.target).closest("form").find(".city").val(data.id);
  });
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  $('#form_autocomplete').typeahead(null, {
    source: window.autocomplete_location,
    displayKey: 'location',
    templates: {
      suggestion: function(data) {
        return '<p>' + data.location + '</p>';
      }
    }
  }).on('typeahead:selected', function(e, data) {
    window.location_val = $(this).val();
    $(event.target).closest("form").find(".city").val(data.id);
  }).on('typeahead:autocompleted', function(e, data) {
    window.location_val = $(this).val();
    $(event.target).closest("form").find(".city").val(data.id);
  });
});
