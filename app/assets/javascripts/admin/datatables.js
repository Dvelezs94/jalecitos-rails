$(document).on('turbolinks:load', function() {
  $('#tablaseo').DataTable({
  language: {
    searchPlaceholder: 'Buscar...',
    sSearch: '',
  }
});
});
