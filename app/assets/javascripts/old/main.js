$(document).on('turbolinks:load', function() {
  "use strict";

  $(".embed-responsive iframe").addClass("embed-responsive-item");
  $(".carousel-inner .item:first-child").addClass("active");

  $('[data-toggle="tooltip"]').tooltip();


  $('#mobile-menu-active').meanmenu({
    meanScreenWidth: "767",
    meanMenuContainer: '.menu-prepent',
  });






  // sidebar
  $('a.redbell1').click(function(event) {
		event.preventDefault();
    $('.belldropdownarea').toggleClass('activee');
    $('a.redbell1').toggleClass('toggle');

  });

  //            $("a.redbell1").on('click', function() {
  //                $(".belldropdownarea").removeClass("hide");
  //            });

  $(".catagorislide-area").on('click', function() {
    $(".belldropdownarea").removeClass("activee");
  });
  //            $(".catagorislide-area").on('click', function() {
  //                $(".belldropdownarea").removeClass("hide");
  //            });

  // sidebar
  $('.bellposition2 a').click(function() {

    $('.belldropdownarea').toggleClass('activee');
    $('.bellposition2 a').toggleClass('toggle');

  });
  // sidebar
  $('.bellposition2 .ex a').click(function() {

    $('.belldropdownarea').toggleClass('activee');
    $('.bellposition2 .ex a').toggleClass('toggle');

  });





  // $("a.redbell1").on("click", function() {

  //     $(".belldropdownarea, .transparentoverlay").addClass("actor");
  // });






  $(".catagori-slidewrap").owlCarousel({
    items: 6,
    nav: true,
    dot: false,
    loop: true,
    margin: 75,
    autoplay: true,
    navText: ["<i class='fa fa-angle-left'></i>", "<i class='fa fa-angle-right'></i>"],
    autoplayTimeout: 3000,
    smartSpeed: 1000,
    responsiveClass: true,
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


  });



  $(".total-popularslide").owlCarousel({
    items: 4,
    nav: true,
    dot: false,
    loop: true,
    margin: 20,
    autoplay: true,
    navText: ["<i class='fa fa-angle-left'></i>", "<i class='fa fa-angle-right'></i>"],
    autoplayTimeout: 3000,
    smartSpeed: 1000,
    responsiveClass: true,
    responsive: {
      0: {
        items: 1,

      },
      768: {
        items: 3,

      },
      1000: {
        items: 4,

      }
    }


  });


  $(".ultimoslide-wrap").owlCarousel({
    items: 4,
    nav: true,
    dot: false,
    loop: true,
    margin: 20,
    autoplay: true,
    navText: ["<i class='fa fa-angle-left'></i>", "<i class='fa fa-angle-right'></i>"],
    autoplayTimeout: 3000,
    smartSpeed: 1000,
    responsiveClass: true,
    responsive: {
      0: {
        items: 1,

      },
      768: {
        items: 3,

      },
      1000: {
        items: 4,

      }
    }


  });








});
