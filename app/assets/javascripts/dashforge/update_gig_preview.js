$(document).on('turbolinks:load', function() {
  $(".gig_form :input").on("keyup change", function() {
    $("[preview='" + this.name + "']").html(this.value)
  });
});
