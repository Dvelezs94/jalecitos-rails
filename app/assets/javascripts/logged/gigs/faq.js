$(document).on('turbolinks:load', function() {
  // limits the number of faqs (just in the view)
  $('#faqs_form').on('cocoon:after-insert', function() {
    check_to_hide_or_show_add_link();
    open_the_faq(this);
  });

  $('#faqs_form').on('cocoon:after-remove', function() {
    check_to_hide_or_show_add_link();
  });

  check_to_hide_or_show_add_link();
  current_faqs();

  $("#faq-accordion").on("click", ".faq-collapse",function(){
    $(this).closest('.nested-fields').find('.collapse').toggle('collapse');
  });
  $(document).on("input paste", ".faq-question-input",function(){
    text = $(this).val();
    button = $(this).closest(".nested-fields").find(".faq-question");
    button.html(text || "Pregunta frecuente");
  });
  initialize_names();

});
function current_faqs(){  //gets all ids of current dom faqs (stored in value of inputs)
  faq_list = [];
  $.each($("#faq-accordion > input[type=hidden]"), function( index, elem ) {
    faq_list.push(elem.value);
  });
  console.log(faq_list);
  return faq_list.join(",")
}
function check_to_hide_or_show_add_link() {
  if ($('.nested-fields:visible').length == 5) {
    $('.links #add_faq').hide();
  } else {
    $('.links #add_faq').show();
  }
}
function initialize_names() {
  $.each($(".faq-question-input"), function( index, elem ) {
    $(elem).closest(".nested-fields").find(".faq-question").html(elem.value);
  });
}
function open_the_faq(faqs_form) {
  $(faqs_form).find(".nested-fields:last .collapse").toggle("collapse");
  $(faqs_form).find(".faq-question-input").focus();
  $('html, body').animate({
    scrollTop: ($(faqs_form).find(".nested-fields:last").offset().top-200)
  }, 1000);
}
