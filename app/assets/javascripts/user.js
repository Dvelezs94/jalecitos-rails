//= require rails-ujs
//= require activestorage
//= require turbolinks

//= require jquery3

//= require popper

//= require bootstrap

//= require gritter

//= require cable

//= require messages-script

//= require best_in_place


$(document).ready(function() {
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();
});

$('.best_in_place').bind("ajax:success", function () {$(this).closest('tr').effect('highlight'); });
