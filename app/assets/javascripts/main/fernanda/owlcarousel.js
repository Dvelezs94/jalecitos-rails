$(document).on('turbolinks:load', function() {

    $(".category-carousel").owlCarousel({
      items: 6,
      loop: true,
      autoplay: false,
      stagePadding: 30,
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
      }
      // nav: true,
      // navText : ["<i class='fas fa-angle-left'></i>","<i class='fas fa-angle-right'></i>"]
    });

    $(".gigs-carousel").owlCarousel({
      items: 6,
      loop: false,
      autoplay: false,
      stagePadding: 20,
      responsive: {
        0: {
          items: 2,
          margin: 10

        },
        768: {
          items: 4,
          margin: 10
        },
        1000: {
          items: 3,
          margin: 10
        }
      }

    });
    $(".requests-carousel").owlCarousel({
      items: 6,
      loop: false,
      autoplay: false,
      stagePadding: 20,
      responsive: {
        0: {
          items: 2,
          margin: 10

        },
        1000: {
          items: 3,
          margin: 10
        }
      }
    });
    $(".gig-show-carousel").owlCarousel({
      items: 1,
      loop: true,
      autoplay: true
    });
});
