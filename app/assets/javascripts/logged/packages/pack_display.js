$(document).on('turbolinks:load', function() {
  //if you are in packages form page
  if ($("#packages_form").length == 1) {
    //show the correct trash
    displayTrash();
    //attach the event to the plus
    $(".pack-tab-displayer").on("click", function() {
      event.preventDefault();
      displayTab();
      //move to up if button 2
      if(this.id == "new-package-2") {
        $('html, body').animate({
          scrollTop: ($("#pack-names").offset().top-200)
        }, 1000);
      }
    });

    $("a.erase-all").on("click", function() {
      event.preventDefault();
      var pack_number = this.getAttribute("href");
      var $el = $(this);
      var response = confirm($el.data('confirm') || '¿Quieres borrar este paquete?');
      if (response) {
        deleteFormContent(pack_number);
      }
    });
  }
});

function displayTab() {
  //display the tab
  var hidden_pack = $("#pack-names a[role='tab']:hidden");
  hidden_pack.first().closest("li").removeClass("d-none")
  hidden_pack[0].click();
  pack_num = hidden_pack[0].getAttribute("href");
  if (hidden_pack.length == 1) {
    $(".pack-tab-displayer").closest("li").addClass("d-none");
  }
  //hide other trash icons
  displayTrash();
}
function displayTrash() {
  var displayed_navs = $("#pack-names a[role='tab']").length - $("#pack-names a[role='tab']").closest("li.d-none").length - 1;
  trashes = $(".erase-all");
  $.each(trashes, function( index, trash ) {
    if (index == displayed_navs) {
      $(trash).removeClass("d-none");
    } else {
      $(trash).addClass("d-none");
    }
  });

}

function deleteFormContent(formNumber) {
  if (formNumber > 0) {
    //hide the nav link
    $($("#pack-names a[role='tab']")[formNumber]).closest("li").addClass("d-none");
    $("#pack-names a[role='tab']")[formNumber - 1].click();
    //show the trash icon of earlier form
    $($("a.erase-all")[formNumber - 1]).removeClass("d-none");
  }
  $(".pack-tab-displayer").closest("li").removeClass("d-none");
  $("div#package-" + formNumber).find(":input").val("");
  $(".name-" + formNumber).keyup(); //reinit count
  $(".description-" + formNumber).keyup(); //reinit count
  $("#price-calc-" + formNumber).html("-");
}
