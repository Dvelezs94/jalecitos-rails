//when is leaving, shows the loading, before it is stored in cache, revert all and show content to be useful in cache

//at visit on link show loading and hide anything of content
$(document).on('turbolinks:visit', function() {
  console.log(event);
  showLoading();
});

//also at query
$(document).on('turbolinks:load', function() {
  // $("#transition").removeClass("hidden");
  // $(".main_container").addClass("hidden");
  // $("#the_footer").addClass("hidden");
  $("#search-form").submit(function() {
    showLoading();
  });
  $(".mobile-search-form").submit(function() {
    showLoading();
  });
});
//cache shows before loading refreshed page, so this makes navigation faster for the user.
//this makes cached pages to show
$(document).on('turbolinks:before-cache', function() {
  hideLoading();
});

function hideLoading() {
  $("#transition").addClass("hidden");
  $(".main_container").removeClass("hidden");
  $("#the_footer").removeClass("hidden");
}

function showLoading() {
  $("#transition").removeClass("hidden");
  $(".main_container").addClass("hidden");
  $("#the_footer").addClass("hidden");
  $(".modal").css("display", "none"); // also hide modals
  $("#notifications .toast__container").remove() //remove app notifications
}
