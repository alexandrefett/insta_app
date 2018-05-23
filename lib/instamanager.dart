import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:insta_app/user.dart';

class InstaManager {
  static final InstaManager _instamanager = new InstaManager._internal();

  static const SERVER = 'http://192.168.0.18/api/v1';

  factory InstaManager() {
    return _instamanager;
  }
  InstaManager._internal();

  Future<User> _getProfile(String username) async {
    http.Response response = await http.get(
        "http://10.125.121.64:4567/api/v1/user/$username",
        headers: {"Accept": "application/json"});
    print('URL= ' + response.request.url.toString());
    print(response.body);
    Map data = json.decode(response.body);

    return new User.fromJson(data);
  }

}