$(document).on('turbolinks:load', function() {
  //if you are in packages form page
  if ($("#packages_form").length == 1) {
    $("a.pack-tab-displayer").on("click", function() {
      event.preventDefault();
      displayTab();
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
  //hide other trash icons
  $("a.erase-all:visible").css("display", "none");
  //now display the tab
  var hidden_pack = $(".pack-names a.nav-item:hidden");
  hidden_pack[0].style.display = "block";
  hidden_pack[0].click();
  if (hidden_pack.length == 1) {
    $("a.pack-tab-displayer")[0].style.display = "none";
  }
}

function deleteFormContent(formNumber) {
  if (formNumber > 0) {
    //hide the nav link
    $(".pack-names a.nav-item")[formNumber].style.display = "none";
    $(".pack-names a.nav-item")[formNumber-1].click();
    //show the trash icon of earlier form
    $("a.erase-all")[formNumber-1].style.display = "block";

  }
  $("a.pack-tab-displayer")[0].style.display = "block";
  $(".name-" + formNumber)[0].value = "";
  $(".name-" + formNumber).keyup();
  $("trix-editor[input=description" + formNumber + "]")[0].value = "";
  $("trix-editor[input=description" + formNumber + "]").keyup();
  $(".price-input-" + formNumber)[0].value = "";
}
