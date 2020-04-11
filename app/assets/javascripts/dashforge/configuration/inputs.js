$(document).on('turbolinks:load', function() {
  if( $("#userbirth").length > 0 ) {
    var cleave = new Cleave('#userbirth', {
      date: true,
      delimiter: '/',
      datePattern: ['Y', 'm', 'd']
    });
  }
  if( $("#userphone").length > 0 ) {    
    var cleave = new Cleave('#userphone', {
      phone: true,
      phoneRegionCode: 'mx',
    });
  }
});
