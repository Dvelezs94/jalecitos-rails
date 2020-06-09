$(document).on('turbolinks:load', function() {
  id =$.getUrlVar("modal");
  $("#"+id).modal("show");
});
