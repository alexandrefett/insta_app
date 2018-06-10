import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<bool> _testUserLogged() async {
    print("_testUserLogged");
    final FirebaseUser currentUser = await _auth.currentUser();
    print(currentUser);
    Singleton.instance.firebaseUser = currentUser;
    if(currentUser!=null){
      return true;
    }
    else {
      return false;
    }
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
