function redirectToHome() {
  window.location.href = "/";
}
//phone and desktop
var introapp = "¡Gracias por registrarte en Jalecitos! Te daremos una breve explicación de cómo funciona la app."
var introhome = "Aquí verás los servicios que ofrecen las personas."
var introreq = "Éstos son los Pedidos que hay, en los cuales puedes ofertar."
var searcher = 'Este buscador sirve para encontrar Jales y Pedidos dentro de la zona que desees.'
var moreinfo = 'Si tienes dudas, puedes consultar las guias de usuario en nuestro <a href="https://blog.jalecitos.com/blog/" target="_blank">blog</a>'
//phone
var intronavphone = "En la barra de navegación podrás crear Jales y Pedidos, ir al inicio, al igual que ver tus mensajes y notificaciones."
var intropicprof = "Desde aquí podrás ver tu perfil y acceder a configuración donde puedes agregar información a tu cuenta."
//desktop
var introcreate = "Desde aqui podrás crear Jales y Pedidos"
var intronavdesk = "En la barra de navegación podras ver tus mensajes, notificaciones e ir a tu perfil."
$(document).on('turbolinks:load', function() {
  if (window.location.pathname == "/wizard") {
    var initialWidth = window.innerWidth;
    if (window.innerWidth <= 991) {
      var intro = introJs();
      intro.setOptions({
        nextLabel: ">",
        prevLabel: "<",
        skipLabel: "Saltar",
        doneLabel: "Terminar",
        steps: [{
            intro: introapp
          },
          {
            element: document.getElementsByClassName("wizard_gigs")[0],
            intro: introhome,
            position: 'bottom'
          },
          {
            element: document.getElementsByClassName("wizard_requests")[0],
            intro: introreq,
            position: 'top'
          },
          {
            element: document.getElementById("phone-welcome-menu"),
            intro: intronavphone,
            position: 'top'
          },
          {
            element: document.getElementById("user_pic"),
            intro: intropicprof,
            position: 'left'
          },
          {
            element: document.getElementById("phone-search-icon"),
            intro: searcher,
            position: "top"
          },
          {
            intro: moreinfo,
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
            intro: introapp
          },
          {
            element: document.getElementsByClassName("wizard_gigs")[0],
            intro: introhome,
            position: 'bottom'
          },
          {
            element: document.getElementsByClassName("wizard_requests")[0],
            intro: introreq,
            position: 'top'
          },
          {
            element: document.getElementById("newelementbtndesktop"),
            intro: introcreate,
            position: 'left'
          },
          {
            element: document.getElementById("main-nav-btns"),
            intro: intronavdesk,
            position: 'bottom'
          },
          {
            element: document.getElementById("search-form"),
            intro: searcher
          },
          {
            intro: moreinfo,
          }
        ],
        showStepNumbers: false
      });
    }
    intro.start()

      // clicking 'Done'
      .oncomplete(function() {
        redirectToHome();
      })

      // clicking 'Skip'
      .onexit(function() {
        redirectToHome();
      });
      $(window).resize(function() { //reload if resize because all can dissapear
        if ((initialWidth <= 991 && window.innerWidth > 991) ||  (initialWidth > 991 && window.innerWidth <= 991)) location.reload();
      });
  }
});
