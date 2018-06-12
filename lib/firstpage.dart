import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_app/models/models.dart';
import 'package:insta_app/pages/loginpage.dart';
import 'package:insta_app/pages/mainpage.dart';
import 'package:insta_app/singleton/singleton.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
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

  Future<FirebaseUser> _testUserLogged() async {
    print("_testUserLogged");
    final FirebaseUser currentUser = await _auth.currentUser();
    Singleton.instance.firebaseUser = currentUser;
    return currentUser;
  }

  Future<Profile> _getProfile(String uid) async {
    print("_testProfile");
    DocumentSnapshot doc = await Firestore.instance
        .collection('profile')
        .document(uid).get();
    if(doc.exists) {
      final Profile profile = Profile.fromJson(doc.data);
      Singleton.instance.profile = profile;
    }
    else
      return null;
  }

  Future<Account> _getAccount(String token){

  }

  @override
  void initState() {
    super.initState();
    _testUserLogged().then((bool value) {
      if(value)
        new Future.delayed(new Duration(seconds:5), (){
          Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (BuildContext context) =>  new MainPageApp()));
        });
      else
        new Future.delayed(new Duration(seconds:5), (){
          Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (BuildContext context) =>  new LoginPage()));
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
          child:new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                  new FlutterLogo( size: 150.0 ),
                  new Padding(padding: const EdgeInsets.only(top: 40.0)),
                  new CircularProgressIndicator()
                ]
              )
    );
  }
}
