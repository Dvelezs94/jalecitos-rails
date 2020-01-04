$(document).on('turbolinks:load', function() {
  window.swip = {};
  var cat_csl = new Swiper('.category-carousel', {
    breakpointsInverse: true,
    slidesPerView: 6.5,
    freeMode: true,
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
      freeMode: true,
      observer: true,
      // autoplay: { used for all sliders, i initialize just the first one below with autoplay.start()
      //   delay: 1000
      // },
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
        992: {
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
  if(window.swip.recent_gigs != undefined) {
    window.swip.recent_gigs.params.autoplay.delay = 5000;
    window.swip.recent_gigs.autoplay.start();
  }

  window.gig_show = new Swiper('.gig-show-carousel', {
    loop: true,
    slidesPerView: 1,
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
    // autoplay: {
    //   delay: 3000
    // }
  });
  window.gig_show.on("slideChange", function() {
    stopVideos();
  });
  if ($(".show-slide").length == 3 || $(".youtube_video").length > 0) { //one image only or video(can have many images) doesnt need autoplay
    window.gig_show.autoplay.stop();
  }
  //one image only or video only (and image for sizing) doesnt need arrows
  if ($(".show-slide").length == 3 || ($(".default-img").length == 2 && $(".youtube_video").length == 2)) {
    $('.swiper-button-prev').hide();
    $('.swiper-button-next').hide();
  }
  if ($(".swiper-container-initialized").length > 0) {
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
function stopVideos() {
  $.each($('iframe[src*="youtube.com"]'), function( index, elem ) {
    var src = $(elem).attr('src');
    $(elem).attr('src', '');
    $(elem).attr('src', src);
  });
}
