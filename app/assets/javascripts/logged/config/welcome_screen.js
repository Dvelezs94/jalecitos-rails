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
            intro: 'Aqui podras ver tu perfil y acceder a configuracion.',
            position: 'left'
          },
          {
            element: document.getElementById("menu-open"),
            intro: 'Aqui podras buscar jales y pedidos.',
            position: "right"
          },
          {
            intro: 'Si tienes dudas, puedes consultar las guias de usuario en https://blog.jalecitos.com/',
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
            intro: "Aqui podras crear nuevos jales y pedidos.",
            position: 'left'
          },
          {
            element: document.getElementById("main-nav-btns"),
            intro: 'Aqui podras ver tus transacciones, mensajes, notificaciones y perfil.',
            position: 'bottom'
          },
          {
            element: document.getElementById("search-form"),
            intro: 'Aqui podras buscar jales y pedidos, dependiendo de la zona que elijas'
          },
          {
            intro: 'Si tienes dudas, puedes consultar las guias de usuario en https://blog.jalecitos.com/',
          }
        ],
        showStepNumbers:false
      });
      intro.start();
    }

  }
});
