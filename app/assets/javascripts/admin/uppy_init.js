$(document).on('turbolinks:load', function() {
  if ($("#drag-drop-area").length) {
    var create_banner_url = document.location.protocol +"//"+ document.location.hostname + document.location.pathname;
    var uppy = Uppy.Core({
      restrictions: {
        maxFileSize: 10000000,
        allowedFileTypes: ["image/png", "image/jpeg", "image/gif", "image/webp", "video/mp4", "video/webm"]
      }
    })
    .use(Uppy.Dashboard, {
      inline: true,
      target: '#drag-drop-area',
    })
    .use(Uppy.XHRUpload, {
      endpoint: create_banner_url
    })
    // uppy.use(Uppy.Dropbox, { target: Uppy.Dashboard, companionUrl: 'https://companion.uppy.io' })
    // uppy.use(Uppy.GoogleDrive, { target: Uppy.Dashboard, companionUrl: 'https://companion.uppy.io' })
    // uppy.use(Uppy.Webcam, { target: Uppy.Dashboard, companionUrl: 'https://companion.uppy.io' })

    uppy.on('complete', (result) => {
      location.reload();
    })

    uppy.on('upload-error', (file, error, response) => {
      show_error("Make sure you have all ad blockers disabled");
    })
  }
});
