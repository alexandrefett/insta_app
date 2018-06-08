import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Session {
  static Session instance = new Session._();

  Session._();

  Map<String, String> headers = {};

  Future<Map> get(String url) async {
    print(headers);
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  Future<Map> post(String url, dynamic data) async {
    headers['Accept'] = 'application/json';
    headers['Content-type'] = 'application/json';
    http.Response response = await http.post(url, body: data, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      print('-----cookie-------');
      print(rawCookie);
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}