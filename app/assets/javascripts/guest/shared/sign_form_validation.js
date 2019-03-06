$(document).on('turbolinks:load', function() {
  $(".sign_up_form").validate({
    ignore: [],
    rules: {
      'user[password]': {
        minlength: 6,
        maxlength: 128,
        aNumber: true,
        aLower: true,
        anUpper: true
      },
      'user[password_confirmation]': {
        equalTo: "#user_password_new"
      },
      'g-recaptcha-response': {
        required: true
      }
    }
  });
  $(".sign_in_form").validate({
    rules: {
      'user[password]': {
        minlength: 6,
        maxlength: 128
      }
    }
  });
});

$.validator.addMethod('aNumber', function(value, element) {
    return this.optional(element) || (value.match(/[0-9]/));
  },
  'La contraseña debe contener al menos un número.');

$.validator.addMethod('aLower', function(value, element) {
    return this.optional(element) || (value.match(/[a-z]/));
  },
  'La contraseña debe contener al menos una minúscula.');

$.validator.addMethod('anUpper', function(value, element) {
    return this.optional(element) || (value.match(/[A-Z]/));
  },
  'La contraseña debe contener al menos una mayúscula.');
