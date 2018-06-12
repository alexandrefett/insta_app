import 'dart:async';

import 'package:flutter/material.dart';
import 'package:insta_app/pages/loginpage.dart';
import 'package:insta_app/pages/mainpage.dart';
import 'package:insta_app/singleton/session.dart' as session;

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

  @override
  void initState() {
    super.initState();
    session.loginFirebase().then((firebaseuser){
      if(firebaseuser==null){
        new Future.delayed(new Duration(seconds:5), (){
          Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (BuildContext context) =>  new LoginPage()));
        });
      }
      else {
        session.loginProfile(firebaseuser.uid).then((profile) {
          if(profile==null) {
            session.loginAccount(profile.uid).then((account) {
              new Future.delayed(new Duration(seconds:2), (){
                Navigator.pushReplacement(context,
                    new MaterialPageRoute(builder: (BuildContext context) =>  new MainPageApp()));
              });
            });
          }
        });
      }
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
