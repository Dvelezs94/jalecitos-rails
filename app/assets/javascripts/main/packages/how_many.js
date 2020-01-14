$(document).on('turbolinks:load', function() { //used in gig show
  $('.unit_range').on('input', function (e) {
    field = $(this).closest("[unit_container]").find('.unit_quantity');
    field.val(e.target.value);
    change_price(this);
  });

  $('.unit_quantity').on('input', function (e) {
    var value = parseInt( $(this).val() ); //actual value
    var range = $(this).closest("[unit_container]").find('.unit_range');

    if (value > $(this).attr("max")) { //value is more than limit
      $(this).val($(this).attr("max"));
      range.val($(this).attr("max"));
    }
    else if ( $(this).attr("min") > value ) { //less than min value
      $(this).val($(this).attr("min"));
      range.val($(this).attr("min"));
    }
    else {
      range.val(e.target.value || $(this).attr("min")); //when no value, set slider to min, just for esthetic
    }
    change_price(this);
  });
  $.each($('.unit_range'), function( index, inp ) { //is user goes back, update the label to show the current ammount
    change_price(inp);
  });
});

function change_price (elem) {
  unit_price = $(elem).closest("[pack_price]").attr("pack_price");
  quantity = parseInt($(elem).val());
  base_price = quantity * unit_price ;
  price_label = $(elem).closest("[pack_container]").find('.packa-price');
  if (Number.isNaN(base_price)){
    price_label.html("-");
  }
  else{
    price_label.html(base_price.toLocaleString(undefined, {maximumFractionDigits:1}) + "<sub>MXN</sub>"); // ((base_price+10) * 1.04) * 1.16).toFixed(2), no hire
  }
}
