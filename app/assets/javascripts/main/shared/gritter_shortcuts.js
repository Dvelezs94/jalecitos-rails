function show_notice (text) {
  jQuery.gritter.add({
    image: '/assets/notice.png',
    title: 'Notice',
    text: text
  });
}

function show_success (text) {
  jQuery.gritter.add({
    image: '/assets/success.png',
    title: 'Success',
    text: text
  });
}
function show_error (text) {
  jQuery.gritter.add({
    image: '/assets/error.png',
    title: 'Error',
    text: text
  });
}
