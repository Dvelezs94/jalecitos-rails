function toggleReviewText(event) {
  event.preventDefault();
  complete_text = $(event.target.closest(".single-review")).find(".complete-text")
  truncated_text = $(event.target.closest(".single-review")).find(".truncated-text")
  if ( complete_text.css('display') == 'none' ) {
    //remove suspensive dots
    truncated_text.text( truncated_text.text().substring(0, truncated_text.text().length-3 ) )
    complete_text.show();
    $(event.target).text("Ver menos");
  }
  else{
    truncated_text.text( truncated_text.text()+"..." );
    truncated_text.css('display', 'inline');
    complete_text.hide();

    $(event.target).text("Ver más");
  }
}
