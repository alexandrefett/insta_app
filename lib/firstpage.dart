import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_app/loginpage.dart';
import 'package:insta_app/mainpage.dart';
import 'package:insta_app/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final CircularProgressIndicator progress = new CircularProgressIndicator();


Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'InstaManager',
    options: const FirebaseOptions(
      googleAppID: '1:8181935955:android:f442fb586be1c267',
      gcmSenderID: '8181935955',
      apiKey: 'AIzaSyBaefpr0jIHFdrIFOYWRCnzmlmIlYZqTlk',
      projectID: 'instamanager-908a3',
    ),
  );
  final Firestore firestore = new Firestore(app: app);
//  void main() => runApp(new MyApp(firestore: firestore));
  runApp(new MyApp(firestore: firestore));
}

class MyApp extends StatelessWidget {
  MyApp({this.firestore});

  final Firestore firestore;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Register Page',
        theme: new ThemeData(primarySwatch: Colors.blue),
        home: new FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  State createState() => new FirstPageState();
}

class FirstPageState extends State<FirstPage>{
  User _data = new User();

  Future<bool> _testUserLogged() async {
    print("_testUserLogged");
    final FirebaseUser currentUser = await _auth.currentUser();
    print(currentUser);
    if(currentUser==null)
      return false;
    else
      return true;
  }

  @override
  void initState() {
    super.initState();
    _testUserLogged().then((bool value) {
      if(value)
        new Future.delayed(new Duration(seconds:3), (){
          Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (BuildContext context) =>  new MainPageApp()));
        });
      else
        new Future.delayed(Duration.zero, (){
          Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (BuildContext context) =>  new LoginPage()));
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Center(
          child:new Stack(
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
//                  new Padding(padding: const EdgeInsets.only(top: 40.0)),
                  new FlutterLogo( size: 150.0 ),
                  new Padding(padding: const EdgeInsets.only(top: 40.0)),
                  progress
                ]
              )
            ],
          ),
        )
    );
  }
}
