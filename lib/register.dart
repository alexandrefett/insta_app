import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/models.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        title: 'Requested',
        theme: new ThemeData(primarySwatch: Colors.blue),
        home: new RegisterPage());
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  var email;
  var password;
  var name;

  Future _updateUserInfo(String name) async {
    final UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await _auth.updateProfile(userUpdateInfo);
  }

  Future _registerWithEmail() async {
    try {
      final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password)
          .then((onValue) {
            _updateUserInfo(name);
      });
      final FirebaseUser currentUser = await _auth.currentUser();
      print(currentUser);
    } catch (error) {
      _showAlertLogin("register error");
      print(error);
    }
  }

  void _showAlertLogin(String value) {
    AlertDialog dialog = new AlertDialog(
      content: new Text(value),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: new Text("OK"))
      ],
    );
    showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(fit: StackFit.expand, children: <Widget>[
      new Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
          Widget>[
        new Padding(padding: const EdgeInsets.only(top: 60.0)),
        new Form(
            child: new Theme(
                data: new ThemeData(
                    primarySwatch: Colors.teal,
                    inputDecorationTheme: new InputDecorationTheme(
                        labelStyle:
                            new TextStyle(color: Colors.teal, fontSize: 20.0))),
                child: new Container(
                  padding: const EdgeInsets.all(40.0),
                  child: new Column(children: <Widget>[
                    new TextField(
                        decoration: new InputDecoration(labelText: "Name"),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        onChanged: (String value) {
                          name = value;
                        }),
                    new TextField(
                        decoration: new InputDecoration(labelText: "Email"),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        onChanged: (String value) {
                          email = value;
                        }),
                    new TextField(
                        decoration: new InputDecoration(labelText: "Password"),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        onChanged: (String value) {
                          password = value;
                        }),
                    new Padding(padding: const EdgeInsets.only(top: 20.0)),
                    new MaterialButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: new Text("Register with Email"),
                      onPressed: _registerWithEmail,
                    )
                  ]),
                )))
      ])
      //_testSignInWithGoogle();
    ]));
  }
}
