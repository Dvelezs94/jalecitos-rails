$(document).on('turbolinks:load', function() {
  if ($("#cardForm").length > 0) {
    $('#save-card').on('click', function(event) {
      if ($("#cardForm").valid()) {
        $(this).html("Guardando...");
        event.preventDefault();
        $("#save-card").prop("disabled", true);
        OpenPay.token.extractFormAndCreate('cardForm', success_callbak, error_callbak);
      }
    });
    var success_callbak = function(response) {
      var token_id = response.data.id;
      $('#token_id').val(token_id);
      //dont sent card info to server
      $("#holder_name").prop('disabled', true);
      $("#card_number").prop('disabled', true);
      $("#exp_month").prop('disabled', true);
      $("#exp_year").prop('disabled', true);
      //$("#card_cvv").prop('disabled', true);
      //submit
      $('#cardForm').submit();
    };
    var error_callbak = function(response) {
      $("#save-card").html("Guardar");
      var desc = response.data.description != undefined ? response.data.description : response.message;
      alert("ERROR [" + response.status + "] " + desc);
      $("#save-card").prop("disabled", false);
    };
  }
});
