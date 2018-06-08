import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_app/session.dart';

Profile profile = new Profile();

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  Session session = new Session();
  Stream<Account> _account;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  Future<Account> _getAccount() async {
    if (Singleton.instance.account == null) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      profile.uid = user.uid;
      DocumentSnapshot doc = await Firestore.instance
          .collection('profile')
          .document(user.uid)
          .get();
      print('--------------------');
      print(doc.data);
      if (!doc.exists) return null;
      profile = Profile.fromDoc(doc);
      Singleton.instance.account = await _getLogin(profile);
      return Singleton.instance.account;
    } else {
      return Singleton.instance.account;
    }
  }

  Widget _buildProgress() {
    return new Center(child: new CircularProgressIndicator());
  }

  Widget _buildForm() {
    return new Container(
        padding: const EdgeInsets.all(40.0),
        child: new Form(
            child: new Container(
                padding: const EdgeInsets.all(40.0),
                child: new Column(children: <Widget>[
                  new TextFormField(
                      decoration: new InputDecoration(labelText: "instagram"),
                      keyboardType: TextInputType.emailAddress,
                      controller: usernameController),
                  new TextFormField(
                      decoration: new InputDecoration(labelText: "password"),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      controller: passwordController,),
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
        padding: const EdgeInsets.all(20.0),
        child: new Column(children: <Widget>[
          new CircleAvatar(
            backgroundImage: new NetworkImage(account.profilePicUrl),
            radius: 75.0,
          ),
          new Text(
            account.username,
            style: new TextStyle(
                color: Colors.black87,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
          new Text(
            account.fullName,
            style: new TextStyle(color: Colors.black87, fontSize: 18.0),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Column(children: <Widget>[
                new Text(
                  account.followedBy.toString(),
                  style: new TextStyle(
                      color: Colors.black87,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                new Text(
                  'followers',
                  style: new TextStyle(color: Colors.black87, fontSize: 16.0),
                ),
              ]),
              new Column(
                children: <Widget>[
                  new Text(
                    account.follows.toString(),
                    style: new TextStyle(
                        color: Colors.black87,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  new Text(
                    'following',
                    style: new TextStyle(color: Colors.black87, fontSize: 16.0),
                  )
                ],
              )
            ],
          )
        ]));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _account = _getAccount()?.asStream();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<Account>(
        stream: _account,
        builder: (BuildContext context, AsyncSnapshot<Account> snapshot) {
          print(snapshot.connectionState);
          print(snapshot.hasData);
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return _buildProgress();
            case ConnectionState.waiting:
              return _buildProgress();
            default:
              if (snapshot.hasData)
                return _buildProfile(snapshot.data);
              else
                return _buildForm();
          }
        });
  }

  Future<Account> _getLogin(Profile user) async {
    Map map = user.toMap();
    String data = json.encode(map);
    Map body = await session.post(Endpoint.LOGIN, data);
/*    http.Response response = await http.post(Endpoint.LOGIN,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json"
        },
        body: data);
    Map body = json.decode(response.body);
    */
    Account account = Account.fromJson(body);
    return account;
  }

  Future<StandardResponse> _saveProfile() {
    profile.username = usernameController.text;
    profile.password = usernameController.text;
    Firestore.instance
        .collection('profile')
        .document(profile.uid)
        .setData(profile.toMap())
        .then((value) {
          setState(() {
            _account = _getAccount()?.asStream();
          });
    });
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
