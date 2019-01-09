$(document).on('turbolinks:load', function() {
  if ($(".tax-val").length > 0 ) {
  tax = $(".tax");
  subtotal = $(".subtotal").html().match(/\d+/g).join(".");
  total = $(".total").html().match(/\d+/g).join(".");
  $("#order_billing_profile_id").on("click", function(){
    if ($(this).prop('checked')) {
      iva = (subtotal * 0.16).toFixed(2);
      newtotal = (+total + +iva).toFixed(2);
      $(".tax-val").html("$"+iva+" MXN");
      $(".total").html("$"+newtotal+" MXN");
      tax.show();
    } else {
      tax.hide();
      $(".total").html("$"+total+" MXN");
    }
  });
  }
});
