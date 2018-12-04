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
          url: url
      })
        .then(() => console.log('Successful share'))
        .catch((error) => console.log('Error sharing', error));
    } else {
      console.log("sharing is not supported on this browser");
    }
    event.preventDefault();
  });
});
