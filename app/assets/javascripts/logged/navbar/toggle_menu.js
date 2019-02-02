$(document).on('turbolinks:load', function() {
  $('.menu-open').click(function() {
    $('.toggle-menu').toggleClass('activee');
    $('.menu-open').toggleClass('toggle');

  });



  $('#mobile-menu-active').meanmenu({
    meanScreenWidth: "767",
    meanMenuContainer: '.menu-prepent',
  });
});
