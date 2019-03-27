$(document).on('turbolinks:load', function() {
  window.swip = {};
  var cat_csl = new Swiper('.category-carousel', {
    breakpointsInverse: true,
    slidesPerView: 6.5,
    loop: false,
    spaceBetween: 10,
    breakpoints: {
      0: {
        slidesPerView: 4,
      },
      768: {
        slidesPerView: 5,
      },
      1000: {
        slidesPerView: 6,
      }
    }

  });

  $(".gig-req-carousel").each(function(index, element) {
    var $this = $(this);
    el = new Swiper(this, {
      slidesPerView: "auto",
      centeredSlides: false,
      loop: false,
      observer: true,
      autoplay: {
        delay: 7000
      },
      spaceBetween: 20,
      breakpointsInverse: true,
      breakpoints: {
        0: {
          slidesPerView: 2,
        },
        350: {
          slidesPerView: 2,

        },
        480: {
          slidesPerView: 2,

        },
        768: {
          slidesPerView: 3,
        },
        1000: {
          slidesPerView: 4,
        },
        1200: {
          slidesPerView: 5,
        }
      }

    });
    window.swip[$(element).attr('class').split(' ')[1]] = el;
    el.on('slideChange', function() {
      fillCarousel(this);
    });
  });
  var gig_show = new Swiper('.gig-show-carousel', {
    loop: true,
    slidesPerView: 1,
    autoplay: {
      delay: 3000
    }
  });
  if ($(".show-slide").length - 2 == 1) {
    gig_show.autoplay.stop();
  }
  $(window).resize(function(){
    gig_show.reInit();
  });
  if ($(".swiper-container-initialized").length > 0 ){
    window.dispatchEvent(new Event('resize')); //this fixes the bug of slider loading with turbolinks and cache
  }
});

function fillCarousel(carousel) {
  if (carousel.slides.length - carousel.activeIndex < 8) {
    link_elem = $(carousel.wrapperEl).find(".carousel-paginator:hidden");
    if (link_elem.length > 0) { //useful to not cause errors while moving and waiting for request
      url = link_elem.attr("href");
      link_elem.replaceWith("Cargando más coincidencias"); //replace to avoid send more requests while loading
      $.getScript(url);
    }
  }
}
