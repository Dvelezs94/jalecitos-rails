function generate_error(form_number, index, input) {
  console.log(input);
  var err_span = $(input).next();
  err_span.html("Por favor, llene este campo");
  $(input).addClass("error");
  //add an event to remove errors when writes
  $(input).on("keyup", function() {
    if ($(this).val() != "") {
      err_span.html("");
      $(this).removeClass("error");
    } else {
      err_span.html("Por favor, llene este campo");
      $(this).addClass("error");
    }
    if ($(".is_input.error").length == 0) {
      $(".error-messages").html("");
    }
  });
  return false;
}

function validatePackages() {
  window.some_error = false;
  a = 0, b = 0, c = 0;
  a_form = $(".form_fields_0:not([pack_validate='false'])");
  b_form = $(".form_fields_1:not([pack_validate='false'])");
  c_form = $(".form_fields_2:not([pack_validate='false'])");

  if( (is_filled(a_form) && is_empty(b_form) && is_empty(c_form)) || (is_filled(a_form) && is_filled(b_form) && is_empty(c_form)) || (is_filled(a_form) && is_filled(b_form) && is_filled(c_form)) ) {
    return true;
  }
  //something is wrong if not returns true
  $.each(a_form, function(index, input) {
    if (input.value == "") {
      $(".error-messages").html("Por favor, llene el paquete básico");
      window.some_error = true;
      return generate_error(0, index, input);
    }
  });
  if (window.some_error==true) return false;
  $.each(b_form, function(index, input) {
    if (input.value == "") {
      $(".error-messages").html("Por favor, llene el paquete estándar");
      window.some_error = true;
      return generate_error(1, index, input);
    }
  });
  if (window.some_error==true) return false;
  $.each(c_form, function(index, input) {
    if (input.value == "") {
      $(".error-messages").html("Por favor, llene el paquete premium");
      window.some_error = true;
      return generate_error(2, index, input);
    }
  });
  if (window.some_error==true) return false;
}

function is_filled (inputs) {
  var fill = true;
  $.each(inputs, function(index, input) {
    if (input.value == "") { //input is empty
      fill = false;
      return false;
    }
  });
  return fill;
}

function is_empty (inputs) {
  var empty = true;
  $.each(inputs, function(index, input) {
    if (input.value != "") { //input is empty
      empty = false;
      return false;
    }
  });
  return empty;
}
