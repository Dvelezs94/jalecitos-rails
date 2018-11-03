document.addEventListener("turbolinks:load", function() {
  jQuery('#search-dropdown').on('click', function (e) {
    e.stopPropagation();
  });
});
