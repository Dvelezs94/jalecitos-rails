  $(document).on('turbolinks:load', function() {
  if ($(".price-input").length > 0) {
    init_price_count();
  }
});

function init_price_count() {
  //generate the events
  $(".price-input").keyup(price_calculation);
  //trigger events at load
  $(".price-input").keyup();
}

function price_calculation() {
  number = parseFloat($(this).val());
  input = $(this)[0].className.split(" ")[1].match(/\d+$/)[0];
  if (number >= 100) {
    $("#price-calc-" + input).text("$" + ( ((number+10) * 1.04) * 1.16).toFixed(2) + " MXN");
  } else {
    $("#price-calc-" + input).text("-");
  }
}
