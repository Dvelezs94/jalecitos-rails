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

    owl_gigs = $(".gigs-carousel").owlCarousel({
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
    owl_requests = $(".requests-carousel").owlCarousel({
      items: 6,
      loop: false,
      autoplay: false,
      stagePadding: 20,
      onDragged: fillCarousel(event),
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
    owl_requests.on('dragged.owl.carousel', function() {
      fillCarousel(this);
    });

    $(".gig-show-carousel").owlCarousel({
      items: 1,
      loop: true,
      autoplay: true
    });

});

function fillCarousel(carousel) {
  if ($(carousel).find(".owl-stage div:last").prev().hasClass("active")) {
  link_elem = $(carousel).find(".carousel-paginator:hidden");
  if (link_elem.length > 0){ //useful to not cause errors while moving and waiting for request
    url = link_elem.attr("href");
    link_elem.replaceWith("Cargando más coincidencias"); //replace to avoid send more requests while loading
    $.getScript( url );
  }
  }
}
