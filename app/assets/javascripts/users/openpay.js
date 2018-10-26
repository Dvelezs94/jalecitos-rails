document.addEventListener("turbolinks:load", function() {
  var deviceSessionId = OpenPay.deviceData.setup("cardForm", "device_session_id");
});
