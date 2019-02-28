// Share API action
$(document).on('turbolinks:load', function() {
  $('#share').click(function (event) {
    let url = document.location.href;
    const canonicalElement = document.querySelector('link[rel=canonical]');

    if (canonicalElement !== null) {
      url = canonicalElement.href;
    }

    if (navigator.share) {
      navigator.share({
          title: document.title,
          text: "¡Observa esta liga! Creo es de tu interés.",
          url: url
      })
    } else {
      new Clipboard('#share', {
        text: function() {
          return url;
        }
      });
      alert("La url ha sido copiada en el portapapeles");
    }
    event.preventDefault();
  });
});
