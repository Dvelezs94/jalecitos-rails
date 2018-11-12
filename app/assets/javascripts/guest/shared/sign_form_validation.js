$(document).on('turbolinks:load', function() {
   $(".sign_up_form").validate({
     rules : {
      'user[password]' : {
          minlength : 6
      },
      'user[password_confirmation]' : {
          minlength : 6,
          equalTo : "#user_password_new"
      }
    }
  });
   $(".sign_in_form").validate({
     rules : {
      'user[password]' : {
          minlength : 6
        }
      }
   });
});
