$(document).on('turbolinks:load', function() {
  //no hire
  // $(".min_amount").keyup(adj_max_amt);
  // $(".max_amount").keyup(adj_min_amt);
});

function adj_max_amt() {
  container = $(this).closest("[display_id]");
  max_input = container.find(".max_amount"); //find the input of max_amount
  max_amount = max_input.val(); //check which is the max amount
  if (max_amount != "") {
    $(this).attr("max", max_amount - 1); //adjust max price
  }
  $(this).valid(); //display or clean jquery error
}

function adj_min_amt() {
  container = $(this).closest("[display_id]");
  min_input = container.find(".min_amount"); //find the input of min_amount
  min_amount = min_input.val(); //check which is the value of min input
  if (min_amount != "") {
    $(this).attr("min", parseInt(min_amount) + 1); //adjust min value
  }
  $(this).valid(); //display or clean jquery error
}
