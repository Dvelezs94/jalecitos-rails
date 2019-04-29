$(document).on('turbolinks:load', function() {
  $(".min_amount").keyup(adj_max_amt);
  $(".max_amount").keyup(adj_min_amt);
});

function adj_max_amt () {
  container = $(this).closest("[display_id]");
  max_input = container.find(".max_amount"); //find the input of max_amount
  max_amount = max_input.val(); //check which is the max amount
  $(this).attr("max", max_amount-1); //adjust max price
  if ($(this).val() >= max_amount) {
    show_error("La cantidad mínima de unidades debe ser menor que la máxima");
  }
  $(this).valid(); //display or clean jquery error
}

function adj_min_amt () {
  container = $(this).closest("[display_id]");
  min_input = container.find(".min_amount"); //find the input of min_amount
  min_amount = min_input.val(); //check which is the value of min input
  $(this).attr("min", parseInt(min_amount)+1); //adjust min value
  if ($(this).val() <= min_amount) {
    show_error("La cantidad máxima de unidades debe ser mayor que la mínima");
  }
  $(this).valid(); //display or clean jquery error
}
