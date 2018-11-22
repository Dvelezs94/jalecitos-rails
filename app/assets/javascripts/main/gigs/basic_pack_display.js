$(document).on('turbolinks:load', function() {
  if ($(".gig_header").length > 0) {
    openCity(event, 'basic');
    if ($(".link-0")) {
      $(".link-0").addClass("active");
    }
  }
});
