$(document).on('turbolinks:load', function() {
  // employer
  $(".fa-pending-employer").click(function(){
    alert("El experto está validando esta orden y se pondrá en contacto contigo cuanto antes.");
  });
  $(".fa-waiting-for-bank-approval-employer").click(function(){
    alert("El pago está siendo validado con el banco.");
  });
  // employee
  $(".fa-pending-employee").click(function(){
    alert("Tu aceptacion para el jale esta pendiente. Puedes mandar un mensaje al usuario si tienes dudas antes de comenzar.");
  });
  $(".fa-waiting-for-bank-approval-employee").click(function(){
    alert("El pago está siendo validado con el banco.");
  });
});
