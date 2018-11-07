document.addEventListener("turbolinks:load", function() {
  if (window.location.href.indexOf("users") > -1) {
    $(".google-span").click(function() {
      activateBestSearch();
    });
  }
});
