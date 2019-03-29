// $(document).on('turbolinks:load', function() {
//   // Safari blocks the UI as soon as a form is submitted
//   // This behaviour prevents us from doing animations inside buttons
//   // This is a workaround to give the render engine some time before blocking
//
//   // This depends on jQuery browser to know if the current browser is Safari
//   // We happened to have that dependency when I implemeneted this workaround
//
//   if (isIos()) {
//     document.addEventListener(
//       'click',
//       event => {
//         let element = event.target;
//         if (element.dataset.disableWith) {
//           element.disabled = true;
//           element.innerHTML = element.dataset.disableWith;
//           let $form = $(element).closest('form');
//           if ($form.length) {
//             event.preventDefault();
//             setTimeout(() => $form.submit(), 13);
//           }
//         }
//       },
//       true
//     );
//   }
// });
