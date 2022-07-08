import 'dart:convert';
import 'package:http/http.dart' as http;

class Resources {
  final String secreKey = 'skey_test_5s52k7ilttrvp6n4owa';
  final String urlApiCharges = 'https://api.omise.co/charges';

  Map<String, String> hearder() {
    String basicAuth = 'Basic ${base64Encode(utf8.encode("$secreKey:"))}';
    Map<String, String> headerMap = {};
    headerMap['authorization'] = basicAuth;
    headerMap['Cache-Control'] = 'no-cache';
    headerMap['Content-Type'] = 'application/x-www-form-urlencoded';
    return headerMap;
  }

  postCharges(Map<String, dynamic> data) async {
    Uri uri = Uri.parse(urlApiCharges);
    return await http.post(
      uri,
      headers: hearder(),
      body: data,
    );
  }
}
