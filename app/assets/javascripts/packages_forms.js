function generate_error(form_number) {
    for(var i = 0; i < 3; i++) {
      if ($(".form_fields_"+form_number)[i].value == ""){
        $(".error_span_"+ (form_number*3+i+1) ).html("Por favor, llene este campo");
        break;
      }
    }
}

$( document ).ready(function() {
  $('#packages_form').submit(function() {
    a = 0, b = 0, c = 0;
    for(var i = 0; i < 3; i++) {
      if ($(".form_fields_0")[i].value != ""){
        a +=1;
      }

      if ($(".form_fields_1")[i].value != ""){
        b +=1;
      }

      if ($(".form_fields_2")[i].value != ""){
        c +=1;
      }

    }
    if( (a==3 && b == 0 && c == 0) || (a==3 && b==3 && c==0) || (a==3 && b == 3 && c==3) ){
      return true
    }
    else{
      $(".error-messages").html("");
      $(".error").html("");

      if (a != 3){
        $(".error-messages").html("Por favor, llene el paquete básico");
        generate_error(0);
      }
      else if (b != 3){
        $(".error-messages").html("Por favor, llene el paquete estándar");
        generate_error(1);
      }

      else{
        $(".error-messages").html("Por favor, llene el paquete premium");
        generate_error(2);
      }
      return false
    }
  });
});
