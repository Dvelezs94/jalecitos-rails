$(document).on("click",".toast__close",  function() {
  var parent = $(this).closest('.toast__container') // or var clickedBtnID = this.id
  // alert('you clicked on button #' + parent);
   parent.fadeOut("fast", function() { $(this).remove(); } );
});
