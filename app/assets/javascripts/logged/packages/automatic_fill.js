$(document).on('turbolinks:load', function() {
  //all commented because it didnt work, logic too complex...
  //attach events
  // $("[name=hire_by_0]").change(all_by_sale_method);
  // $(".unit_type").first().change(all_that_unit);
  $(".unit_price").blur( fill_max_units);
  //execute all at start
  // $("[name=hire_by_0]").change();
  // $(".unit_type").first().change();
});
function fill_max_units() {
  max_amount = $(this).closest("[display_id]").find(".max_amount");
  if ( max_amount.val() == "" ) {
    max_amount.val( parseInt(10000/this.value)  )
  }
}

// function all_by_sale_method() {
//   if ($(".package-nav:not(.hidden)").length == 1) { //just is editing first package
//     if ($(this).hasClass("by_unit")) {
//       radios = $(".by_unit");
//       $("[display_class=by_service]").addClass("hidden");
//     } else {
//       radios = $(".by_service");
//       $("[display_class=by_unit]").addClass("hidden");
//     }
//     radios.click(); //display the same sale method in the others (service or unit)
//   }
// }
//
// function all_that_unit() {
//   if ($(".package-nav:not(.hidden)").length == 1) { //just is editing first package
//     $(".unit_type").val(this.value)
//   }
// }
