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

  $(document).on("click", ".faq-collapse",function(){
    $(this).closest('.nested-fields').find('.collapse').toggle('collapse');
  });
  $(document).on("input paste", ".faq-question-input",function(){
    text = $(this).val();
    button = $(this).closest(".nested-fields").find(".faq-question");
    button.html(text || "Pregunta frecuente");
  });
  initialize_names();

});
function check_to_hide_or_show_add_link() {
  if ($('.nested-fields').length == 5) {
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
  console.log($(faqs_form).find(".nested-fields:last-child .collapse"));
  $(faqs_form).find(".nested-fields:last .collapse").toggle("collapse");
}
