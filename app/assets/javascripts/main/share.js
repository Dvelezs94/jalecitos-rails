// Share API action
$(document).on('turbolinks:load', function() {
  $('.fa-share-alt').click(function (event) {
    let url = document.location.href;
    elem='#share';
    desk="¡Observa esta liga! Creo es de tu interés.";
    text=`${url}`;
    confirmation = "La url ha sido copiada en el portapapeles";
    share_content(elem,desk,text,confirmation, url);
    event.preventDefault();
  });
});
