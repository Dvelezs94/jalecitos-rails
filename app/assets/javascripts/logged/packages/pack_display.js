$(document).on('turbolinks:load', function() {
  //if you are in packages form page
  if ($("#packages_form").length == 1) {
    firstDisplay();
    $("#pack-plus").click(displayPack);
    $("#pack-minus").click(hidePack);
  }
});
function displayedPackages(totalForms){
  displayed = 0;
  for (var i = 0; i < totalForms; i++) {
    //check how many packages are displayed
    if ( $(".form-number-" + i)[0].style.display == "block" ) {
      displayed +=1;
    }
    if (i == totalForms-1){
      return displayed;
    }
  }
}

function firstDisplay() {
  totalForms = $(".form-number").length;
  for (var i = 1; i < totalForms; i++) {
    //dont display unfilled packages, statring from the second one
    if ( $(".name-"+i)[0].value == "" ) {
      xform = $(".form-number-" + i);
      xform[0].style.display = "none";
    }
  }
  //check displayed packages to determine if show plus and minus
  displayed = displayedPackages(totalForms);

  if ( displayed < totalForms ) {
    xplus = $("#pack-plus");
    xplus[0].style.display = "block";
  }

  if ( displayed > 1 ) {
    xminus = $("#pack-minus");
    xminus[0].style.display = "block";
  }

}

function displayPack() {
  totalForms = $(".form-number").length;
  formNumber = displayedPackages(totalForms);

  //display the block and set minus
  $(".form-number-" + formNumber)[0].style.display = "block";
  $("#pack-minus")[0].style.display = "block";

  //possibly hide plus
  if(formNumber + 1 == totalForms){
    $("#pack-plus")[0].style.display = "none";
  }

}

function hidePack() {
  totalForms = $(".form-number").length;
  formNumber = displayedPackages(totalForms)-1;

  //hide the block and set plus
  $(".form-number-" + formNumber)[0].style.display = "none";
  $("#pack-plus")[0].style.display = "block";

  //delete content of hidden form_block
  deleteFormContent(formNumber);

  //possibly hide minus
  if(formNumber-1 == 0){
    $("#pack-minus")[0].style.display = "none";
  }

}

function deleteFormContent(formNumber){
  $(".name-"+formNumber)[0].value = "";
    $(".name-"+formNumber).keyup();
  $("trix-editor[input=description" + formNumber + "]")[0].value = "";
  $("trix-editor[input=description" + formNumber + "]").keyup();
  $(".price-input-"+formNumber)[0].value = "";
}
