$(document).on('turbolinks:load', function() {
  $(".gig_form :input").on("keyup change", function() {
    $("[preview='" + this.name + "']").html(this.value);
    });
    $("#faqs_form").on("keyup change", ":input", function() {
      update_faq_accordion();
    });
    $('#faqs_form').on('cocoon:after-remove', function(e, insertedItem, originalEvent) {
    update_faq_accordion();
  });
});

//faq accordion functions
function update_faq_accordion() {
  //update accordion
  accordion = $("#preview-accordion");
  accordion.html("");
  //with not display none (on edit, when removes something, cocoon hides it, i think maybe is for knowing which stuff delete)
  $.each($(".nested-fields:not([style*='display: none'])"), function( index, elem ) {
    question = $(elem).find("input:last").val();
    answer = $(elem).find("textarea").val();
    if (question != "") {
      accordion.append("<h3>"+ question + "</h3><div><p>"+ answer +"</p></div>");
    }
  });
  accordion.accordion('destroy').accordion();
}


// carousel functions
function append_to_carousel(image_url) {
  carousel = $("#gig-preview-carousel");
  carousel.find(".carousel-inner").append("<div class='carousel-item gig'><img src="+ image_url +" alt='...'></div>");
  //if has preview images, delete them
  carousel.find(".carousel-inner .preview").remove();
  //show uploaded image
  carousel.find(".active").removeClass("active");
  carousel.find(".carousel-inner > div:last-child").addClass("active");

  carousel.carousel();

}
function delete_from_carousel(image_url) {
  carousel = $("#gig-preview-carousel");
  element = carousel.find("img[src='"+ image_url +"']").closest("div");
  if (element.hasClass("active")) { // if the active image is deleted, then i need to display another
    carousel.find(".carousel-inner > div:not(.active):first").addClass("active");
  }
  element.remove();
}
