$(document).on('turbolinks:load', function() {
  if ($('.file-input')) {
    $('.file-input').fileinput({
      theme: 'fa',
      language: 'es',
      showUpload: false,
      'allowedFileExtensions': ['jpg', 'png', 'gif', 'jpeg'],
      uploadUrl: '#',
      maxFileCount: 5,
      maxFileSize: 10240
    });
  }
});
