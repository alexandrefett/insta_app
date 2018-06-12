import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_app/models/models.dart';
import 'package:insta_app/singleton/session.dart' as session;
import 'package:insta_app/singleton/singleton.dart';
import 'package:charts_flutter/flutter.dart' as charts;

Profile profile = new Profile();

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {

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
                    controller: passwordController,
                  ),
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
          ),
          new Padding(
            padding: new EdgeInsets.all(32.0),
            child: new SizedBox(
            height: 100.0,
            child: _buildChart(Singleton.instance.firebaseUser.uid),
          ))
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return _buildProfile(Singleton.instance.account);
  }
  /*
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<Account>(
        future: Singleton.instance.account,
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
*/
  Future<List<charts.Series<History, DateTime>>> _getData(String uid) async {
    List<History> list = new List<History>();
    QuerySnapshot data = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('history')
        .orderBy('date')
        .getDocuments();

    var docs = data.documents;
    docs.forEach((element) {
      print(element.data);
      list.add(new History.fromDoc(element));
    });

    return [
      new charts.Series<History, DateTime>(
          id: 'Followers',
          data: list,
          domainFn: (History followers, _) => followers.date,
          measureFn: (History followers, _) => followers.followers)
    ];
  }

  Widget _buildChart(String uid) {
    return new FutureBuilder<List<charts.Series<History, DateTime>>>(
        future: _getData(uid),
        builder: (BuildContext context,
            AsyncSnapshot<List<charts.Series<History, DateTime>>> snapshot) {
          if(snapshot.hasData)
            return new charts.TimeSeriesChart(snapshot.data,
              animate: true,
              dateTimeFactory: const charts.LocalDateTimeFactory());
          else
            return _buildProgress();
        });
  }

  Future<String> _saveProfile() {
    profile.username = usernameController.text;
    profile.password = passwordController.text;
    Firestore.instance
        .collection('profile')
        .document(profile.uid)
        .setData(profile.toMap())
        .then((value) {
      setState(() {
        //_account = Singleton.instance.login().asStream();
      });
    });
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
