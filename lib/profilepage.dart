import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/standardresponse.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_app/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

var _user = new User();

_saveInstagramData(User user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', user.username);
  await prefs.setString('password', user.password);
}

Future<User> _getInstagramData() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String username = await prefs.get('username');
  String password = await prefs.get('password');
  return new User(username: username, password: password);
}

Future<StandardResponse> _login(User user) async {
  print("login...");
  Map map = user.toMap();
  String data = json.encode(map);

  http.Response response = await http.post("http://192.168.0.25:8080/api/v1/login",
      headers: {
        "Accept":"application/json",
        "Content-type":"application/json"
      },
      body: data
  );
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  Firestore firestore;

  Future<Firestore> connect() async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'InstaManager',
      options: const FirebaseOptions(
        googleAppID: '1:8181935955:android:f442fb586be1c267',
        gcmSenderID: '8181935955',
        apiKey: 'AIzaSyBaefpr0jIHFdrIFOYWRCnzmlmIlYZqTlk',
        projectID: 'instamanager-908a3',
      ),
    );
    return new Firestore(app: app);
  }

  Widget _form() {
    return new Form(
        child: new Theme(
            data: new ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.teal,
                inputDecorationTheme: new InputDecorationTheme(
                    labelStyle:
                        new TextStyle(color: Colors.teal, fontSize: 20.0))),
            child: new Container(
                padding: const EdgeInsets.all(40.0),
                child: new Column(children: <Widget>[
                  new TextField(
                      decoration: new InputDecoration(labelText: "instagram"),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (String value) {
                          _user.username = value;
                      }),
                  new TextField(
                      decoration: new InputDecoration(labelText: "password"),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      onChanged: (String value) {
                        _user.password = value;
                      }),
                  new Padding(padding: const EdgeInsets.only(top: 20.0)),
                  new MaterialButton(
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: new Text("save"),
                    onPressed: _saveInstagramData(_user),
                    minWidth: 200.0,
                  ),
                ]))));
  }

  @override
  void initState() {
    _getInstagramData().then((User user){_user = user;});
    if(_user.username != null && _user.password != null){
      _login(_user);
    }
//    connect().then((Firestore firestore) {
//      this.firestore = firestore;
//    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}
