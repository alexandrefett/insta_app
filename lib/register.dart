import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/user.dart';
import 'package:insta_app/standardresponse.dart';

class RegisterScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        title: 'Requested',
        theme: new ThemeData(
            primarySwatch: Colors.blue
        ),
        home: new RegisterPage()
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage>{

  User _data = new User();

  Future<String> _register(User _data) async{
    print("register");
    http.Response response = await http.post("http://192.168.0.25:4567/api/v1/register",
        body: json.encode(_data),
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
    _register(this._data);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white30,
        body: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:<Widget>[
                    new Padding(padding: const EdgeInsets.only(top: 60.0)),
                    new Form(
                        child: new Theme(
                            data: new ThemeData(
                                primarySwatch: Colors.black12,
                                inputDecorationTheme: new InputDecorationTheme(
                                    labelStyle: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0
                                    ))),
                            child: new Container(
                              padding: const EdgeInsets.all(40.0) ,
                              child: new Column(
                                  children: <Widget>[
                                    new TextField(
                                        decoration: new InputDecoration(
                                            labelText: "Instagram"
                                        ),
                                        keyboardType: TextInputType.text,
                                        obscureText: true,
                                        onChanged: (String value) {
                                          this._data.instagram = value;
                                        }
                                    ),
                                    new TextField(
                                        decoration: new InputDecoration(
                                            labelText: "instagram password"
                                        ),
                                        keyboardType: TextInputType.text,
                                        obscureText: true,
                                        onChanged: (String value) {
                                          this._data.instaPassword = value;
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

