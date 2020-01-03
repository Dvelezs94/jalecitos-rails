$(document).on('turbolinks:load', function() {
  if ($(".current_form").length > 0) {
    $(".current_form").validate();
  }
  if ($(".gig_form").length > 0) {
    $(".gig_form").validate({
      ignore: [],
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
  if ($(".new_card").length > 0) {
    $(".new_card").validate();
  }
  if ($(".new_bank").length > 0) {
    $(".new_bank").validate();
  }
  if ($(".reportForm").length > 0) {
    $(".reportForm").validate();
  }
  if ($(".review_form").length > 0) {
    review_validation();
  }
  if ($(".new_billing_profile").length > 0) {
    $(".new_billing_profile").validate();
  }
  if ($(".new_billing_profile").length > 0) {
    $(".new_billing_profile").validate();
  }
  if ($(".search-form-guest").length > 0) {
    $(".search-form-guest").validate();
  }
  if ($(".report_request_form").length > 0) {
    $(".report_request_form").validate();
  }
  if ($(".edit_review_form").length > 0) {
    $(".edit_review_form").validate();
  }
});
