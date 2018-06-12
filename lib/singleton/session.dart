import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Session {

  static const DOMAIN_V1 = 'http://186.228.87.125:8080/api/v1';
  static const LOGIN = DOMAIN_V1 + '/login';
  static const GET_ACCOUNT = DOMAIN_V1 + '/account';
  static const GET_PROFILE = DOMAIN_V1 + '/profile';
  static const GET_SEARCH = DOMAIN_V1 + '/search';
  static const GET_FOLLOWS = DOMAIN_V1 + '/follows';
  static const GET_FOLLOWERS = DOMAIN_V1 + '/followers';

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