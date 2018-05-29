import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _db = Firestore.instance;


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  bool _isLoading = true;
  bool _isLogin = false;
  bool _isProfile = false;

  Profile _profile = new Profile();
  Account _account = new Account();

  Widget _buildProgress(){
    return new Center(
        child: new CircularProgressIndicator());
  }

  Widget _buildForm() {
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
                          this._profile.username = value;
                      }),
                  new TextField(
                      decoration: new InputDecoration(labelText: "password"),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      onChanged: (String value) {
                        this._profile.password = value;
                      }),
                  new Padding(padding: const EdgeInsets.only(top: 20.0)),
                  new MaterialButton(
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: new Text("save"),
                    onPressed: _saveProfile,
                    minWidth: 200.0,
                  ),
                ]))));
  }

  Widget _buildProfile(Account account) {
    return new Container(
                padding: const EdgeInsets.all(40.0),
                child: new Column(children: <Widget>[
                  new CircleAvatar(backgroundImage: new NetworkImage(account.profilePictureUrl)),
                    new Text(account.username),
                    new Text(account.fullName)
                ]));
  }

  @override
  void initState() {
    _login();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading)
      return _buildProgress();
    else
      if(!_isProfile)
        return _buildForm();
      if(_isLogin)
        return _buildProfile(_account);
  }

  Future<Account> _login(){
    _auth.currentUser().then((user){
      print('--------------auth user');
      print(user);
        this._profile.uid = user.uid;
        _getProfile(user.uid).then((profile){
          print('--------------profile');
            print(profile);
            if(profile==null){
              setState(() {
                _isProfile = false;
                _isLogin = false;
                _isLogin = false;
              });
              return null;
            }
            else{
              _getLogin(profile).then((response){
                print('--------------account');
                  print(response);
                  if(response.status=="SUCCESS"){
                      _account = Account.fromJson(response.data);
                      setState(() {
                      _isProfile = true;
                      _isLogin = true;
                      _isLoading = false;
                    });
                  }
                  else{
                    setState(() {
                      _isProfile = true;
                      _isLogin = false;
                      _isLoading = false;
                    });
                  }
              });
            }
      });
    });

  }

  Future<Profile> _getProfile(String uid) async {
    var profile;
    print('--------------1');

    DocumentReference doc =
    Firestore.instance.collection('profile').document(uid);
    print('--------------2');

    doc.get().then((onValue) {
      print('--------------3');
      print(onValue);
      if (onValue.exists) {
        print('--------------4');
        profile = Profile.fromJson(onValue.data);
        return profile;
      }
    });
  }

  Future<StandardResponse> _getLogin(Profile user) async {
    print("_login...$user");
    Map map = user.toMap();
    String data = json.encode(map);
    var url = Endpoint.LOGIN;
    http.Response response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json"
        },
        body: data);
    Map body = json.decode(response.body);
    return new StandardResponse.fromJson(body);
  }

  Future<StandardResponse> _saveProfile(){
    setState(() {
      _isLoading = true;
    });
    Firestore.instance
        .collection('profile')
        .document(_profile.uid)
        .setData(_profile.toMap()).then((value){
          _login();
    });
  }

}
