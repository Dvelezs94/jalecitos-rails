$(document).on('turbolinks:load', function() {
  if ($(".current_form").length > 0) {
    $(".current_form").validate();
  }
  if ($(".gig_form").length > 0) {
    $(".gig_form").validate({
      ignore: ':hidden:not(.do-not-ignore)', //city field have to be ignored when hidden, but faqs dont, put this class to faqs so they dont be ignored in validation
      highlight: function(element, errorClass) { //opens modal of faq when validation fails so the user can see the failure
        if($(element).hasClass("faq-field") && $(element).is(":hidden")){
          $(element).closest(".nested-fields").find(".faq-collapse").click();
        }
    }
    });
  }
  if ($(".pack_form").length > 0) {
    $(".pack_form").validate({
      ignore: []
    });
  }
  if ($(".reportForm").length > 0) {
    $(".reportForm").validate();
  }
  if ($(".review_form").length > 0) {
    review_validation();
  }
  if ($(".report_request_form").length > 0) {
    $(".report_request_form").validate();
  }
  if ($(".editReviewForm").length > 0) {
    $(".editReviewForm").validate();
  }
});
