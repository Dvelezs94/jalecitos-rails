$(document).on('turbolinks:load', function() {

    $(".category-carousel").owlCarousel({
      items: 6,
      loop: true,
      autoplay: true,
      responsive: {
        0: {
          items: 2,
          margin: 10,

        },
        768: {
          items: 4,

        },
        1000: {
          items: 6,

        }
      },
      nav: true,
      navText : ["<i class='fa fa-angle-left'></i>","<i class='fa fa-angle-right'></i>"]
    });

});
