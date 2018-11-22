$(document).on('turbolinks:load', function() {
  if ($(".price-input").length > 0) {
    init_price_count();
  }
});

function init_price_count() {
  $(".price-input").keyup(price_calculation);
  for (var i = 0; i < 3; i++) {
    priceInput = $(".price-input-" + i)
      priceInput.keyup();
  }

}
function price_calculation() {
  number = $(this)[0].value;
  input = $(this)[0].className.split(" ")[1].match(/\d+$/)[0];
  if (number >= 100){
  $("#price-calc-" + input).text("$"+(number*1.1).toFixed(2)+ " MXN");
  }
  else{
    $("#price-calc-" + input).text("-");
  }
}
