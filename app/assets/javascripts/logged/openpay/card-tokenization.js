$(document).on('turbolinks:load', function() {
  if ($("#cardForm").length > 0) {
    $('#save-card').on('click', function(event) {
      event.preventDefault();
      $("#save-card").prop("disabled", true);
      OpenPay.token.extractFormAndCreate('cardForm', success_callbak, error_callbak);
    });
    var success_callbak = function(response) {
      var token_id = response.data.id;
      $('#token_id').val(token_id);
      $('#cardForm').submit();
    };
    var error_callbak = function(response) {
      var desc = response.data.description != undefined ? response.data.description : response.message;
      alert("ERROR [" + response.status + "] " + desc);
      $("#save-card").prop("disabled", false);
    };
  }
});
