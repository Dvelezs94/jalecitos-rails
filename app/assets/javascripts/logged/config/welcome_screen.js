$(document).on('turbolinks:load', function() {
  if (($.getUrlVar("wizard") === "true")) {
    $("#welcomeScreen").show();
  }
});
