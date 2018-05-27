import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:insta_app/user.dart';

class InstaManager {
  static final InstaManager _instamanager = new InstaManager._internal();

  static const SERVER = 'http://192.168.0.18/api/v1/{{method}}';
  static const GET_PROFILE = '/profile';
  static const POST_PROFILE = '/register';

  factory InstaManager() {
    return _instamanager;
  }

  InstaManager._internal();

  String _getMethod(String method){
    return SERVER.replaceAll('{{method}}', method);
  }

  Future<User> _getProfile(String token) async {

    String url = _getMethod(GET_PROFILE);
    print(url);
    http.Response response = await http.get(url,
        headers: {"Accept": "application/json"});
    print('URL= ' + response.request.url.toString());
    print(response.body);
    Map data = json.decode(response.body);
    return new User.fromJson(data);
  }

  Future<User> _postProfile(User user) async {
    http.Response response = await http.post(url)get(
        "http://10.125.121.64:4567/api/v1/user/$username",
        headers: {"Accept": "application/json"});
    print('URL= ' + response.request.url.toString());
    print(response.body);
    Map data = json.decode(response.body);

    return new User.fromJson(data);
  }

}