$(document).on('turbolinks:load', function() {
  if (window.location.href.indexOf("gigs") > -1 && window.location.href.indexOf("new") == -1 && window.location.href.indexOf("edit") == -1) {
    $(document).on("turbolinks:before-visit", function() {
      $('.product__slider-main').slick('slickSetOption', 'autoplay', false).slick('slickPause');
    });
    if ($('.product__slider-main').length) {
      var $slider = $('.product__slider-main')
        .on('init', function(slick) {
          $('.product__slider-main').fadeIn(1000);
        })
        .slick({
          slidesToShow: 1,
          slidesToScroll: 1,
          arrows: true,
          autoplay: true,
          lazyLoad: 'ondemand',
          autoplaySpeed: 3000,
          asNavFor: '.product__slider-thmb'
        });

      var $slider2 = $('.product__slider-thmb')
        .on('init', function(slick) {
          $('.product__slider-thmb').fadeIn(1000);
        })
        .slick({
          slidesToShow: 4,
          slidesToScroll: 1,
          lazyLoad: 'ondemand',
          asNavFor: '.product__slider-main',
          dots: false,
          centerMode: false,
          focusOnSelect: true
        });

      //remove active class from all thumbnail slides
      $('.product__slider-thmb .slick-slide').removeClass('slick-active');

      //set active class to first thumbnail slides
      $('.product__slider-thmb .slick-slide').eq(0).addClass('slick-active');

      // On before slide change match active thumbnail to current slide
      $('.product__slider-main').on('beforeChange', function(event, slick, currentSlide, nextSlide) {
        var mySlideNumber = nextSlide;
        $('.product__slider-thmb .slick-slide').removeClass('slick-active');
        $('.product__slider-thmb .slick-slide').eq(mySlideNumber).addClass('slick-active');
      });

      var options = {
        progressbarSelector: '.bJS_progressbar',
        slideSelector: '.bJS_slider',
        previewSlideSelector: '.bJS_previewSlider',
        progressInterval: ''
          // add your own progressbar animation function to sync it i.e. with a video
          // function will be called if the current preview slider item (".b_previewItem") has the data-customprogressbar="true" property set
          ,
        onCustomProgressbar: function($slide, $progressbar) {}
      }

      // slick slider options
      // see: https://kenwheeler.github.io/slick/
      var sliderOptions = {
        slidesToShow: 1,
        slidesToScroll: 1,
        arrows: false,
        fade: true,
        autoplay: true
      }

      // slick slider options
      // see: https://kenwheeler.github.io/slick/
      var previewSliderOptions = {
        slidesToShow: 3,
        slidesToScroll: 1,
        dots: false,
        focusOnSelect: true,
        centerMode: true
      }
    }
  }
});
