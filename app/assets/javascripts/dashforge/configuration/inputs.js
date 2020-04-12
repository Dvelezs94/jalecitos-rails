//https://jsfiddle.net/nosir/0amruddk/ this is demo of select
$(document).on('turbolinks:load', function() {
  if ($("#userbirth").length > 0) {
    var cleave = new Cleave('#userbirth', {
      date: true,
      delimiter: '/',
      datePattern: ['Y', 'm', 'd']
    });
  }
  if ($("#userphone").length > 0) {
    window.cleavePhone = new Cleave('#userphone', {
      phone: true
    });
    initCodeSelect();
  }

  $("#user_image").change(function() {
    updateImagePreview(this);
  });


});

function initCodeSelect() {
var code={BD:"880",BE:"32",BF:"226",BG:"359",BA:"387",BB:"1",WF:"681",BL:"590",BM:"1",BN:"673",BO:"591",BH:"973",BI:"257",BJ:"229",BT:"975",JM:"1",BW:"267",WS:"685",BQ:"599",BR:"55",BS:"1",JE:"44",BY:"375",BZ:"501",RU:"7",RW:"250",RS:"381",TL:"670",RE:"262",TM:"993",TJ:"992",RO:"40",TK:"690",GW:"245",GU:"1",GT:"502",GR:"30",GQ:"240",GP:"590",JP:"81",GY:"592",GG:"44",GF:"594",GE:"995",GD:"1",GB:"44",GA:"241",SV:"503",GN:"224",GM:"220",GL:"299",GI:"350",GH:"233",OM:"968",TN:"216",JO:"962",HR:"385",HT:"509",HU:"36",HK:"852",HN:"504",VE:"58",PR:"1",PS:"970",PW:"680",PT:"351",SJ:"47",PY:"595",IQ:"964",PA:"507",PF:"689",PG:"675",PE:"51",PK:"92",PH:"63",PN:"870",PL:"48",PM:"508",ZM:"260",EH:"212",EE:"372",EG:"20",ZA:"27",EC:"593",IT:"39",VN:"84",SB:"677",ET:"251",SO:"252",ZW:"263",SA:"966",ES:"34",ER:"291",ME:"382",MD:"373",MG:"261",MF:"590",MA:"212",MC:"377",UZ:"998",MM:"95",ML:"223",MO:"853",MN:"976",MH:"692",MK:"389",MU:"230",MT:"356",MW:"265",MV:"960",MQ:"596",MP:"1",MS:"1",MR:"222",IM:"44",UG:"256",TZ:"255",MY:"60",MX:"52",IL:"972",FR:"33",IO:"246",SH:"290",FI:"358",FJ:"679",FK:"500",FM:"691",FO:"298",NI:"505",NL:"31",NO:"47",NA:"264",VU:"678",NC:"687",NE:"227",NF:"672",NG:"234",NZ:"64",NP:"977",NR:"674",NU:"683",CK:"682",CI:"225",CH:"41",CO:"57",CN:"86",CM:"237",CL:"56",CC:"61",CA:"1",CG:"242",CF:"236",CD:"243",CZ:"420",CY:"357",CX:"61",CR:"506",CW:"599",CV:"238",CU:"53",SZ:"268",SY:"963",SX:"599",KG:"996",KE:"254",SS:"211",SR:"597",KI:"686",KH:"855",KN:"1",KM:"269",ST:"239",SK:"421",KR:"82",SI:"386",KP:"850",KW:"965",SN:"221",SM:"378",SL:"232",SC:"248",KZ:"7",KY:"1",SG:"65",SE:"46",SD:"249",DO:"1",DM:"1",DJ:"253",DK:"45",VG:"1",DE:"49",YE:"967",DZ:"213",US:"1",UY:"598",YT:"262",UM:"1",LB:"961",LC:"1",LA:"856",TV:"688",TW:"886",TT:"1",TR:"90",LK:"94",LI:"423",LV:"371",TO:"676",LT:"370",LU:"352",LR:"231",LS:"266",TH:"66",TG:"228",TD:"235",TC:"1",LY:"218",VA:"379",VC:"1",AE:"971",AD:"376",AG:"1",AF:"93",AI:"1",VI:"1",IS:"354",IR:"98",AM:"374",AL:"355",AO:"244",AS:"1",AR:"54",AU:"61",AT:"43",AW:"297",IN:"91",AX:"358",AZ:"994",IE:"353",ID:"62",UA:"380",QA:"974",MZ:"258"};
  var selectCountry = $('#select-country');
  var html = '';

  for (var i in code) {
    html += '<option value="+' + code[i] + '">' + i + '</option>';
  }

  selectCountry.html(html);
  selectCountry.val('+52');

  selectCountry.on('change', function() {
    window.cleavePhone.setPhoneRegionCode(this.value);
    window.cleavePhone.setRawValue(this.value);
    $('#userphone').focus();
  });
}
