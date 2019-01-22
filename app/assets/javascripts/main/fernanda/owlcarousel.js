$(document).on('turbolinks:load', function() {

    $(".category-carousel").owlCarousel({
      items: 6,
      loop: true,
      autoplay: false,
      responsive: {
        0: {
          items: 2.4,
          margin: 10,

        },
        768: {
          items: 4.3,

        },
        1000: {
          items: 6.3,

        }
      }
      // nav: true,
      // navText : ["<i class='fas fa-angle-left'></i>","<i class='fas fa-angle-right'></i>"]
    });

    $(".gigs-carousel").owlCarousel({
      items: 6,
      loop: true,
      autoplay: false,
      responsive: {
        0: {
          items: 2.4,
          margin: 10

        },
        768: {
          items: 4.4,
          margin: 10
        },
        1000: {
          items: 3.3,
          margin: 10
        }
      }
      // nav: true,
      // navText : ["<i class='fas fa-angle-left'></i>","<i class='fas fa-angle-right'></i>"]
    });
});
