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
    else if ( 1 <= value && value <= $(this).attr("max")) { //value is correct
      range.val(e.target.value);
    }
    else { //less than 1 or empty
      $(this).val(1);
      range.val(1);
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
  price_label.html("$" + base_price.toFixed(2) + "<sub>MXN</sub>"); // ((base_price+10) * 1.04) * 1.16).toFixed(2), no hire
}
