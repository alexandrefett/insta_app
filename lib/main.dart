import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:insta_app/user.dart';
import 'register.dart';
import 'navigator.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return new MaterialApp(
        title: 'Register Page',
        theme: new ThemeData(primarySwatch: Colors.blue),
        home: new LoginPage(),
        routes: <String, WidgetBuilder>{
//          "/second": (BuildContext context) => new Requested(),
          "/registerWithEmail": (BuildContext context) => new RegisterScreen(),
          "/navigator": (BuildContext context) => new BottomNavigationDemo()

        });
  }
}

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>{
  User _data = new User();

  Future<bool> _testUserLogged() async {
    print("_testUserLogged");
    final FirebaseUser currentUser = await _auth.currentUser();
    if(currentUser==null)
      return false;
    else
      return true;
  }

  Future<String> _registerWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
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
    return 'signInWithGoogle succeeded: $user';
  }

  Future<FirebaseUser> _testUserLogged2() async {
    print("_testUserLogged");
      final FirebaseUser currentUser = await _auth.currentUser()
          .then((FirebaseUser user) {
              print(user);
              Navigator.of(context).pushNamed("/navigator");
          });
  }


  Future<String> _login(User _data) async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: _data.email, password: _data.password);
    if (user != null) {
      print(user.email);
      print(user.displayName);
      //getuser
    }
  }

  void submit() {
    _login(this._data);
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
        context: this.context, builder: (BuildContext context) => dialog);
  }

  @override
  void initState() {
    _testUserLogged().then((bool value) {
      new Future.delayed(Duration.zero, () {
        Navigator.of(context).pushNamed("/navigator");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(fit: StackFit.expand, children: <Widget>[
      new Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
          Widget>[
        new Padding(padding: const EdgeInsets.only(top: 40.0)),
        new FlutterLogo(
          size: 100.0,
        ),
        new Form(
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
                        decoration: new InputDecoration(labelText: "Email"),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (String value) {
                          this._data.email = value;
                        }),
                    new TextField(
                        decoration: new InputDecoration(labelText: "Password"),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        onChanged: (String value) {
                          this._data.password = value;
                        }),
                    new Padding(padding: const EdgeInsets.only(top: 20.0)),
                    new MaterialButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: new Text("Login"),
                      onPressed: this.submit,
                      minWidth: 200.0,
                    ),
                    new Padding(padding: const EdgeInsets.only(top: 20.0)),
                    new MaterialButton(
                      textColor: Colors.blueGrey,
                      child: new Text("Esqueci a senha"),
                      onPressed: this.submit,
                      minWidth: 200.0,
                    ),
                    new Padding(padding: const EdgeInsets.only(top: 20.0)),
                    new MaterialButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: new Text("Register with Email"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context) => new RegisterScreen()),
                        );
                      },
                      minWidth: 200.0,
                    ),
                    new Padding(padding: const EdgeInsets.only(top: 20.0)),
                    new MaterialButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: new Text("Login with Google"),
                      onPressed: _registerWithGoogle,
                      minWidth: 200.0,
                    )

                  ]),
                )))
      ])
    ])
    );
  }
}
