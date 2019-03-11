$(document).on('turbolinks:load', function() {
  window.swip = {};
  var cat_csl = new Swiper('.category-carousel', {
    slidesPerView: 6.5,
    loop: true,
    spaceBetween: 10,
    breakpoints: {
       1000: {
         slidesPerView: 5.5
       },
       768: {
         slidesPerView: 4.5

       }
     }
  });

  $(".gig-req-carousel").each(function(index, element){
    var $this = $(this);
    el = new Swiper(this, {
      slidesPerView: "auto",
      centeredSlides: false,
      loop: false,
      observer: true,
      spaceBetween: 10,
      breakpointsInverse: true,
      breakpoints: {
        320: {
          slidesPerView: 2
        },
        768: {
          slidesPerView: 3.5
        },
        1000: {
          slidesPerView: 4.5
        },
        1200: {
          slidesPerView: 5.5
        }
      }
    });
    window.swip[$(element).attr('class').split(' ')[1]] = el;
    el.on('slideChange', function () {
      fillCarousel(this);
    });
  });
  var gig_show = new Swiper('.gig-show-carousel', {
    loop: true,
    slidesPerView: 1,
    autoplay: {
      delay: 5000
    }
});

});

function fillCarousel(carousel) {
  if (carousel.slides.length - carousel.activeIndex  < 8) {
    link_elem = $(carousel.wrapperEl).find(".carousel-paginator:hidden");
    if (link_elem.length > 0) { //useful to not cause errors while moving and waiting for request
      url = link_elem.attr("href");
      link_elem.replaceWith("Cargando más coincidencias"); //replace to avoid send more requests while loading
      $.getScript(url);
    }
  }
}
