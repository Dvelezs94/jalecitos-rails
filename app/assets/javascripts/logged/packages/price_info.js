$(document).on('turbolinks:load', function() {
  if ($(".pack-price-class").length > 0) {
    init_price_count();
  }
});

function init_price_count() {
  $(".price-input").keyup(price_calculation);
  for (var i = 0; i < 3; i++) {
    priceInput = $(".price-input-" + i)
    if(priceInput[0].value != ""){
      priceInput.keyup();
    }
  }

}
function price_calculation() {
  input = $(this)[0].className.split(" ")[1].match(/\d+$/)[0];
  number = $(this)[0].value;
  $("#price-calc-" + input).text("$"+(number*1.1).toFixed(2)+ " MXN");
}
