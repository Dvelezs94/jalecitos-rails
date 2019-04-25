$(document).on('turbolinks:load', function() {
  $(".max_amount").keyup(adj_max_unit_price);
  $(".unit_price").keyup(adj_max_amount);
});

function adj_max_unit_price () {
  container = $(this).closest("[display_id]");
  input = container.find(".unit_price"); //find the input of price
  max_price = (10000/$(this).val()).toFixed(1); //check which is the max price
  input.attr("max", max_price); //adjust max price
  if ($(input).val() > max_price) {
    show_error("La cantidad máxima de unidades a vender multiplicadas por su precio unitario supera los 10,000 MXN");
  }
  input.valid(); //display or clean jquery error
}

function adj_max_amount () {
  container = $(this).closest("[display_id]");
  input = container.find(".max_amount"); //find the input of max_amount
  max_price = parseInt(10000/$(this).val()); //check which is the max amount
  input.attr("max", max_price); //adjust max amount
  if ($(input).val() > max_price) {
    show_error("La cantidad máxima de unidades a vender multiplicadas por su precio unitario supera los 10,000 MXN");
  }
  input.valid(); //display or clean jquery error
}
