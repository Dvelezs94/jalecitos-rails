const userAgent = window.navigator.userAgent.toLowerCase();
const isIos = () => {
  return /iphone|ipad|ipod/.test( userAgent );
}

const isAndroid = () => {
  return /android/.test( userAgent );
}
