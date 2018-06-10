import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_app/models/models.dart';
import 'package:insta_app/singleton/session.dart';
import 'package:insta_app/singleton/singleton.dart';
import 'package:charts_flutter/flutter.dart' as charts;
Profile profile = new Profile();

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  Session session = Session.instance;
  Stream<Account> _account;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

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
    _account = Singleton.instance.login().asStream();
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

  Widget _buildChart(String uid){
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('users')
          .document(uid)
          .collection('history')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return new ListTile(
              title: new Text(document['title']),
              subtitle: new Text(document['author']),
            );
          }).toList(),
        );
      },
    );
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
            _account = Singleton.instance.login().asStream();
          });
    });
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
