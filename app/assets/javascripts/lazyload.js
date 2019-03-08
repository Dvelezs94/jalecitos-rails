$(document).on('turbolinks:load', function() {
  $("img").lazyload({
    skip_invisible : false
  });
});
