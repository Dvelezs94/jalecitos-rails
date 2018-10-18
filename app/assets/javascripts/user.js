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

//= require jquery-fileupload/basic

//=require users


$(document).ready(function() {
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();

  /* for image upload */
  // $("#profileImage").click(function(e) {
  //    $("#imageUpload").click();
  //  });
  //
  //  function fasterPreview( uploader ) {
  //      if ( uploader.files && uploader.files[0] ){
  //            $('#profileImage').attr('src',
  //               window.URL.createObjectURL(uploader.files[0]) );
  //      }
  //  }
  //
  //  $("#imageUpload").change(function(){
  //      fasterPreview( this );
  // });


});
