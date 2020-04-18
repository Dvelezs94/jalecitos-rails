function share_content(elem, desk, text, confirmation, url){

  const canonicalElement = document.querySelector('link[rel=canonical]');
  if (canonicalElement !== null) {
    url = canonicalElement.href;
  }
  if (navigator.share) {
    navigator.share({
        title: document.title,
        text: desk,
        url: url
    })
  } else {
  new Clipboard(elem, {
      text: function() {
        return text;
      }
    });

    alert(confirmation);
  }
  event.preventDefault();
}
