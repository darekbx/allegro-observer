import 'dart:async';

class Authenticator {

  final _clientId = "c878432370b44ea0b84a1ca8b294894e";
  final _redirectUrl = "http://google.pl";
  final _redirectUrlTemplate = "https://www.google.pl/?code=";
  final _redirectUrlSuffix = "&gws_rd=ssl";

  String getAuthUrl() =>
      "https://allegro.pl/auth/oauth/authorize?response_type=code&client_id=${_clientId}&redirect_uri=${_redirectUrl}";

  String extractCode(String url) {
    if (url.startsWith(_redirectUrlTemplate)) {
      String code = url.substring(_redirectUrlTemplate.length);
      print("A: $code");
      var endIndex = code.length - _redirectUrlSuffix.length;
      return code.substring(0, endIndex);;
    }
    return null;
  }
}