import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  //String baseurl = "https://bloktest.herokuapp.com";
  String baseurl = "http://10.0.2.2:5000";
  var log = Logger();
  //final storage = new FlutterSecureStorage();
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future get(String url) async {
    String token = await storage.read(key: "token");
    //print(token);
    url = formatter(url);
    var response =
        await http.get(url, headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return json.decode(response.body);
    }

    log.i(response.body);
    log.i(response.statusCode);
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    url = formatter(url);
     String token = await storage.read(key: "token");
    var response = await http.post(url,
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(body));

    log.d(response.body);
    log.d(response.statusCode);
    return response;
  }

  String formatter(String url) {
    return baseurl + url;
  }
}
