$(document).on('turbolinks:load', function() {
  if (window.location.href.indexOf("gigs") > -1 && window.location.href.indexOf("new") == -1 && window.location.href.indexOf("edit") == -1) {
    openCity(event, 'basic');
    if ( $(".link-0") ){
      $(".link-0").addClass("active");
    }
  }
});
