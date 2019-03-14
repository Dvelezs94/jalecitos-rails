$(document).on('turbolinks:load', function() {
  $("textarea.name-class").scroll(function() {
    if ($(this).scrollTop() > 0) {
      $("span.action-gig").css("display", "none");
    }
    else {
      $("span.action-gig").css("display", "block");
    }
  });
});
