function fadeNotification(){
  setTimeout(function() {
      $('.toast__container').fadeOut('slow');
      }  , 5000); // <-- time in milliseconds
}

$(document).on("click",".toast__close",  function() {
  var parent = $(this).closest('.toast__container') // or var clickedBtnID = this.id
  // alert('you clicked on button #' + parent);
   parent.fadeOut("slow", function() { $(this).remove(); } );
});
