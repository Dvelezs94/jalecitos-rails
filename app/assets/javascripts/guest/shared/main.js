$(document).on('turbolinks:load', function() {

  $(".regular").slick({
    dots: true,
    infinite: true,
    slidesToShow: 1,
    slidesToScroll: 1,
    arrows: true,
  });


  $(".center").slick({
    dots: false,
    infinite: false,
    centerMode: false,
    slidesToShow: 5,
    slidesToScroll: 3,
    responsive: [
{
  breakpoint: 1024,
  settings: {
    slidesToShow: 3,
    slidesToScroll: 3,
    infinite: true,
    dots: true
  }
},
{
  breakpoint: 600,
  settings: {
    slidesToShow: 2,
    slidesToScroll: 2,
    dots: true
  }
},
{
  breakpoint: 480,
  settings: {
    slidesToShow: 1,
    slidesToScroll: 1,
    dots: true
  }
}
]
  });

});
