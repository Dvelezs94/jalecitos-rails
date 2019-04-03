function generate_error(form_number) {
  for (var i = 0; i < 3; i++) {
    if ($(".form_fields_" + form_number)[i].value == "") {
      var err_span = $(".error_span_" + (form_number * 3 + i + 1));
      err_span.html("Por favor, llene este campo");
      input = $(".error_span_" + (form_number * 3 + i + 1)).closest(".form-block").find(".is_input");
      input.addClass("error");
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
      break;
    }
  }
}

function validatePackages() {
  a = 0, b = 0, c = 0;
  for (var i = 0; i < 3; i++) {
    if ($(".form_fields_0")[i].value != "") {
      a += 1;
    }

    if ($(".form_fields_1")[i].value != "") {
      b += 1;
    }

    if ($(".form_fields_2")[i].value != "") {
      c += 1;
    }

  }
  if ((a == 3 && b == 0 && c == 0) || (a == 3 && b == 3 && c == 0) || (a == 3 && b == 3 && c == 3)) {
    return true
  } else {
    $(".error-messages").html("");
    $(".span-error").html("");

    if (a != 3) {
      $(".error-messages").html("Por favor, llene el paquete básico");
      generate_error(0);
    } else if (b != 3) {
      $(".error-messages").html("Por favor, llene el paquete estándar o borre su contenido");
      generate_error(1);
    } else {
      $(".error-messages").html("Por favor, llene el paquete premium o borre su contenido");
      generate_error(2);
    }
    return false
  }
}
