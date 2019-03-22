$(document).on('turbolinks:load', function() {
  if ($(".price-input").length > 0) {
    init_price_count();
  }
});

function init_price_count() {
  //generate the events
  $(".price-input").keyup(price_calculation);
  //trigger events at load
  for (var i = 0; i < 3; i++) {
    priceInput = $(".price-input-" + i)
    priceInput.keyup();
  }

}

function price_calculation() {
  number = parseFloat($(this)[0].value);
  input = $(this)[0].className.split(" ")[1].match(/\d+$/)[0];
  if (number >= 100) {
    $("#price-calc-" + input).text("$" + ( ((number+10) * 1.04) * 1.16).toFixed(2) + " MXN");
    $("#base-price-" + input).val(number);
  } else {
    $("#price-calc-" + input).text("-");
    $("#base-price-" + input).val("");
  }
}
