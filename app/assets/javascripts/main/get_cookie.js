// Get cookie from jquery.
// usage: getCookie("samplename")
// var myCookie = getCookie("samplename");
//
// if (myCookie == null) {
//    alert("cookie does not exist");
// } else {
//    alert("cookie exists");
// }

function getCookie(name) {
    var cookie = document.cookie;
    var prefix = name + "=";
    var begin = cookie.indexOf("; " + prefix);
    if (begin == -1) {
        begin = cookie.indexOf(prefix);
        if (begin != 0) return null;
    } else {
        begin += 2;
        var end = document.cookie.indexOf(";", begin);
        if (end == -1) {
        end = cookie.length;
        }
    }
    return unescape(cookie.substring(begin + prefix.length, end));
}
