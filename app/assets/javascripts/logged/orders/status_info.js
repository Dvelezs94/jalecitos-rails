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
    alert("El cliente está esperando tu solicitud para comenzar el jale. En caso de ya haber solicitado el inicio, comunicarse con el usuario para su aceptación.");
  });
  $(".fa-waiting-for-bank-approval-employee").click(function(){
    alert("El pago está siendo validado con el banco.");
  });
});
