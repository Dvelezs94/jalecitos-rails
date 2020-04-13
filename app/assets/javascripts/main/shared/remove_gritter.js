$(document).on('turbolinks:before-cache', function() {
  toastr.remove();
});
