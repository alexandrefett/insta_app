import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/standardresponse.dart';
import 'package:insta_app/requestedpage.dart';

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

  @override
  Widget build(BuildContext context) {

    void _pushToSecond(){
      Navigator.pushNamed(
          context,
          "/second");
    }

    return new MaterialApp(
      title: 'Insta Manager',
      theme: new ThemeData( primarySwatch: Colors.blue),
      home: new LoginPage(),
      routes:<String, WidgetBuilder>{
        "/second":(BuildContext context) => new Requested()
      }
    );
  }
}

class _LoginData {
  String user = '';
  String password = '';
}

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{

  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  _LoginData _data = new _LoginData();

  Future<String> _login(_LoginData _data) async{
    print("login");
    http.Response response = await http.get("http://10.125.121.64:4567/api/v1/login?username=${_data.user}&password=${_data.password}",
        headers: {
          "Accept":"application/json"
        }
    );
    print(response.body);

    Map data = json.decode(response.body);
    var dataAccount = new StandardResponse.fromJson(data);
    if(dataAccount.status=="SUCCESS")
      Navigator.pushNamed(this.context,"/second");
    else
      _showAlertLogin(dataAccount.status);
  }

  void submit() {
      _login(this._data);
  }

  void _showAlertLogin(String value){
    AlertDialog dialog = new AlertDialog(
      content: new Text(value),
      actions: <Widget>[
        new FlatButton(
            onPressed: (){},
            child: new Text("OK")
        )
      ],
    );
    showDialog(context: this.context, builder: (BuildContext context) => dialog);
  }

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
                        new TextField(
                            decoration: new InputDecoration(
                                labelText: "usuario"
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (String value) {
                              this._data.user = value;
                            }
                        ),
                        new TextField(
                            decoration: new InputDecoration(
                                labelText: "senha"
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            onChanged: (String value) {
                              this._data.password = value;
                            }
                        ),
                        new Padding(padding: const EdgeInsets.only(top: 20.0)),
                        new MaterialButton(
                          color: Colors.teal,
                          textColor: Colors.white,
                          child: new Text("Login"),
                          onPressed: this.submit,
                          splashColor: Colors.redAccent,
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

