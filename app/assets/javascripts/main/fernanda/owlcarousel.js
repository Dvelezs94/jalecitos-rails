$(document).on('turbolinks:load', function() {

  if ($(".category-carousel").length > 0) {
      owl_cat = $(".category-carousel").owlCarousel({
        items: 6,
        loop: true,
        nav: false,
        autoplay: false,
        stagePadding: 30,
        responsive: {
          0: {
            items: 4,
            margin: 10,
            stagePadding: 10

          },
          768: {
            items: 5,

          },
          1000: {
            items: 6,

          }
        }
        // nav: true,
        // navText : ["<i class='fas fa-angle-left'></i>","<i class='fas fa-angle-right'></i>"]
      });

  }
  if ($(".gigs-carousel").length > 0) {
    owl_gigs = $(".gigs-carousel").owlCarousel({
      items: 6,
      loop: false,
      autoplay: false,
      stagePadding: 20,
      responsive: {
        0: {
          items: 1,
          margin: 5,
          stagePadding: 68

        },
        350: {
          items: 2,
          margin: 5,
          stagePadding: 5
        },
        400: {
          items: 2,
          margin: 10
        },
        480: {
          items: 2,
          margin: 10

        },
        768: {
          items: 3,
          margin: 10
        },
        1000: {
          items: 4,
          margin: 10
        },
        1200: {
          items: 5,
          margin: 10
        }
      }

    });
    owl_gigs.on('dragged.owl.carousel', function() {
      fillCarousel(this);
    });
  }
  if ($(".requests-carousel").length > 0) {
    owl_requests = $(".requests-carousel").owlCarousel({
      items: 6,
      loop: false,
      autoplay: false,
      stagePadding: 20,
      responsive: {
        0: {
          items: 1,
          margin: 5,
          stagePadding: 68

        },
        350: {
          items: 2,
          margin: 5,
          stagePadding: 5
        },
        400: {
          items: 2,
          margin: 10
        },
        480: {
          items: 2,
          margin: 10

        },
        768: {
          items: 3,
          margin: 10
        },
        1000: {
          items: 4,
          margin: 10
        },
        1200: {
          items: 5,
          margin: 10
        }
      }

    });

    owl_requests.on('dragged.owl.carousel', function() {
      fillCarousel(this);
    });
  }
  if ($(".gig-show-carousel").length > 0) {
    $(".gig-show-carousel").owlCarousel({
      items: 1,
      loop: true,
      autoplay: true
    });
  }
});

$(document).on('turbolinks:before-cache', function() {
  $('.category-carousel').owlCarousel('destroy');
  $('.gigs-carousel').owlCarousel('destroy');
  $('.requests-carousel').owlCarousel('destroy');
  $('.gig-show-carousel').owlCarousel('destroy');
});


function fillCarousel(carousel) {
  if ($(carousel).find(".owl-stage div:last").prev().hasClass("active")) {
    link_elem = $(carousel).find(".carousel-paginator:hidden");
    if (link_elem.length > 0) { //useful to not cause errors while moving and waiting for request
      url = link_elem.attr("href");
      link_elem.replaceWith("Cargando más coincidencias"); //replace to avoid send more requests while loading
      $.getScript(url);
    }
  }
}
