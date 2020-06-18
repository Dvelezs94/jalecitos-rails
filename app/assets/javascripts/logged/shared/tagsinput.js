$(document).on('turbolinks:load', function() {
  $('.tagsinput').tagsinput({
    maxTags: 20,
    maxChars: 50,
    confirmKeys: [13, 44]
  });
});
