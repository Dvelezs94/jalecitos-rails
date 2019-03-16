$(document).on('turbolinks:load', function() {
  if (($.getUrlVar("wizard") === "true")) {
    if (screen.width <= 991) {
      var intro = introJs();
      intro.setOptions({
        steps: [
          {
            intro: "Gracias por registrarte en Jalecitos! Te daremos un recorrido por la aplicacion."
          },
          {
            element: document.getElementById("configuration-page"),
            intro: "Aqui podras configurar tu cuenta, agregar  tarjetas y retirar dinero.",
            position: 'bottom'
          },
          {
            element: document.getElementById("phone-welcome-menu"),
            intro: "En la barra inferior podras crear jales, ver tus transacciones, ir al inicio, al igual que ver tus mensajes y notificaciones.",
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
        showStepNumbers:false
      });
      intro.start();
    } else {
      var intro = introJs();
      intro.setOptions({
        steps: [
          {
            intro: "Gracias por registrarte en Jalecitos! Te daremos un recorrido por la aplicacion."
          },
          {
            element: document.getElementById("configuration-page"),
            intro: "Aqui podras configurar tu cuenta, agregar  tarjetas y retirar dinero.",
            position: 'bottom'
          },
          {
            element: document.getElementById('newelementbtndesktop'),
            intro: "Con este boton podras crear nuevos jales y pedidos",
            position: 'left'
          },
          {
            element: document.getElementById("main-nav-btns"),
            intro: 'En esta barra podras ver tus transacciones, mensajes, notificaciones y perfil.',
            position: 'bottom'
          },
          {
            element: document.getElementById("search-form"),
            intro: 'Este buscador sirve para encontrar jales y pedidos dentro de la zona.'
          },
          {
            intro: 'Si tienes dudas, puedes consultar las guias de usuario en nuestro <a href="https://blog.jalecitos.com/blog/" target="_blank">blog</a>',
          }
        ],
        showStepNumbers:false
      });
      intro.start();
    }

  }
});
