//when is leaving, shows the loading, before it is stored in cache, revert all and show content to be useful in cache

//at click on link show loading and hide anything of content
$(document).on('turbolinks:click', function() {
  $("#transition").removeClass("hidden");
  $(".main_container").addClass("hidden");
  $("#the_footer").addClass("hidden");
});

//cache shows before loading refreshed page, so this makes navigation faster for the user.
//this makes cached pages to show
$(document).on('turbolinks:before-cache', function() {
  $("#transition").addClass("hidden");
  $(".main_container").removeClass("hidden");
  $("#the_footer").removeClass("hidden");
});
