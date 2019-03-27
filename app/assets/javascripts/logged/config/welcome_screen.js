function redirectToHome() {
  window.location.href = "/";
}
$(document).on('turbolinks:load', function() {
  if (($.getUrlVar("wizard") === "true")) {
    if (screen.width <= 991) {
      var intro = introJs();
      intro.setOptions({
        nextLabel: ">",
        prevLabel: "<",
        skipLabel: "Saltar",
        doneLabel: "Terminar",
        steps: [{
            intro: "Gracias por registrarte en Jalecitos! Te daremos un recorrido por la aplicacion."
          },
          {
            element: document.getElementsByClassName("popular_gigs")[0],
            intro: "Esta es la seccion de jales, aqui podras contratar servicios.",
            position: 'top'
          },
          {
            element: document.getElementsByClassName("recent_requests")[0],
            intro: "Estos son los pedidos que hay, en los cuales puedes ofertar.",
            position: 'top'
          },
          {
            element: document.getElementById("phone-welcome-menu"),
            intro: "En la barra de navegacion podras crear Jales y Pedidos, ver tus transacciones, ir al inicio, al igual que ver tus mensajes y notificaciones.",
            position: 'top'
          },
          {
            element: document.getElementById("user_pic"),
            intro: 'Desde aqui podras ver tu perfil y acceder a configuracion.',
            position: 'left'
          },
          {
            element: document.getElementById("menu-open"),
            intro: 'Este buscador sirve para encontrar jales y pedidos dentro de la zona.',
            position: "right"
          },
          {
            intro: 'Si tienes dudas, puedes consultar las guias de usuario en nuestro <a href="https://blog.jalecitos.com/blog/" target="_blank">blog</a>',
          }
        ],
        showStepNumbers: false
      });
    } else {
      var intro = introJs();
      intro.setOptions({
        nextLabel: "Siguiente",
        prevLabel: "Anterior",
        skipLabel: "Saltar",
        doneLabel: "Terminar",
        steps: [{
            intro: "Gracias por registrarte en Jalecitos! Te daremos un recorrido por la aplicacion."
          },
          {
            element: document.getElementsByClassName("popular_gigs")[0],
            intro: "Esta es la seccion de jales, aqui podras contratar servicios.",
            position: 'bottom'
          },
          {
            element: document.getElementsByClassName("recent_requests")[0],
            intro: "Estos son los pedidos que hay, en los cuales puedes ofertar.",
            position: 'top'
          },
          {
            element: document.getElementById("newelementbtndesktop"),
            intro: "Desde aqui podras crear jales y pedidos",
            position: 'left'
          },
          {
            element: document.getElementById("main-nav-btns"),
            intro: 'En esta barra podras ver tus transacciones, mensajes, notificaciones y perfil.',
            position: 'bottom'
          },
          {
            element: document.getElementById("search-form"),
            intro: 'Este buscador sirve para encontrar jales y pedidos.'
          },
          {
            intro: 'Si tienes dudas, puedes consultar las guias de usuario en nuestro <a href="https://blog.jalecitos.com/blog/" target="_blank">blog</a>',
          }
        ],
        showStepNumbers: false
      });
    }
    intro.start()

      // clicking 'Done'
      .oncomplete(function() {
        redirectToHome()
      })

      // clicking 'Skip'
      .onexit(function() {
        redirectToHome()
      });
  }
});
