import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

Future<String> _testSignInWithGoogle() async {
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth =
  await googleUser.authentication;
  final FirebaseUser user = await _auth.signInWithGoogle(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  assert(user.email != null);
  assert(user.displayName != null);
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  print("this work user: $user");
  return 'signInWithGoogle succeeded: $user';
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Insta Manager',
      theme: new ThemeData( primarySwatch: Colors.blue),
      home: new LoginPage()
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{

  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this,
      duration: new Duration(milliseconds: 500)
    );
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeOut
    );
    _iconAnimation.addListener(()=>this.setState((){}));
    _iconAnimationController.forward();

  }


  @override
  Widget build(BuildContext context){
    return new Scaffold(
      backgroundColor: Colors.white30,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
              new Padding(padding: const EdgeInsets.only(top: 60.0)),
              new FlutterLogo(
                size:_iconAnimation.value * 100,
              ),
              new Form(
                  child: new Theme(
                    data: new ThemeData(
                      brightness: Brightness.dark,
                      primarySwatch: Colors.teal,
                      inputDecorationTheme: new InputDecorationTheme(
                        labelStyle: new TextStyle(
                          color: Colors.teal,
                          fontSize: 20.0
                        ))),
                  child: new Container(
                    padding: const EdgeInsets.all(40.0) ,
                    child: new Column(
                      children: <Widget>[
                        new TextFormField(
                            decoration: new InputDecoration(
                                labelText: "usuario"
                            ),
                            keyboardType: TextInputType.text
                        ),
                        new TextFormField(
                            decoration: new InputDecoration(
                                labelText: "senha"
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true
                        ),
                        new Padding(padding: const EdgeInsets.only(top: 20.0)),
                        new MaterialButton(
                          color: Colors.teal,
                          textColor: Colors.white,
                          child: new Text("Login"),
                          onPressed:()=>{}
                        )
                      ]
                    ),
                  )
              )
          )
        ]
      )
  //_testSignInWithGoogle();
    ]
    )
    );
    }
  }


