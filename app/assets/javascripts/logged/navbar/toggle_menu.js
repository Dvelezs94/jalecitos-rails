$(document).on('turbolinks:load', function() {
  $('#mobile-menu-active').meanmenu({
    meanScreenWidth: "767",
    meanMenuContainer: '.menu-prepent',
  });
});
