$(document).on('turbolinks:load', function() {
  //if you are in packages form page
  if ($("#packages_form").length == 1) {
    //show the correct trash
    displayTrash();
    //attach the event to the plus
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
  //display the tab
  var hidden_pack = $(".pack-names a.nav-item:hidden");
  hidden_pack[0].style.display = "block";
  hidden_pack[0].click();
  if (hidden_pack.length == 1) {
    $("a.pack-tab-displayer")[0].style.display = "none";
  }
  //hide other trash icons
  displayTrash();
}
function displayTrash() {
  var displayed_navs = $(".package-nav:visible").length - 1;
  for (i = 0; i < $(".erase-all").length; i++) {
    if (i == displayed_navs) {
      $("a.erase-all")[i].style.display = "block";
    } else {
      $("a.erase-all")[i].style.display = "none";
    }
  }
}

function deleteFormContent(formNumber) {
  if (formNumber > 0) {
    //hide the nav link
    $(".pack-names a.nav-item")[formNumber].style.display = "none";
    $(".pack-names a.nav-item")[formNumber - 1].click();
    //show the trash icon of earlier form
    $("a.erase-all")[formNumber - 1].style.display = "block";

  }
  $("a.pack-tab-displayer")[0].style.display = "block";
  $(".name-" + formNumber)[0].value = "";
  $(".name-" + formNumber).keyup();
  $(".description-" + formNumber)[0].value = "";
  $(".price-input-" + formNumber)[0].value = "";
  $("#price-calc-" + formNumber).html("-");
  $("#base-price-" + formNumber).val("");
}
