import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  Firestore firestore;
  var _list = new List<MiniAccount>();
  var search;

  Future<Firestore> connect() async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'InstaManager',
      options: const FirebaseOptions(
        googleAppID: '1:8181935955:android:f442fb586be1c267',
        gcmSenderID: '8181935955',
        apiKey: 'AIzaSyBaefpr0jIHFdrIFOYWRCnzmlmIlYZqTlk',
        projectID: 'instamanager-908a3',
      ),
    );
    return new Firestore(app: app);
  }

  @override
  void initState() {
    connect().then((Firestore firestore) {
      this.firestore = firestore;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      new Row(children: <Widget>[
        new TextField(
            keyboardType: TextInputType.text,
            onChanged: (String value) {
              this.search = value;
            }),
        new FlatButton(
            onPressed: null,
            child: new IconButton(
                icon: new Icon(Icons.keyboard_return), onPressed: _search))
      ]),
      new ListView.builder(
          itemCount: _list.length,
          itemBuilder: (BuildContext context, int index) {
            MiniAccount account = _list[index];
            return new ListTile(
                leading: new CircleAvatar(
                    child: new Image.network(account.profilePicUrl)),
                title: new Text(account.username),
                subtitle: new Text(account.username));
          })
    ]);
  }

  void _search() {
    _getSearch(search).then((List<MiniAccount> list) {
      setState(() {
        this._list = list;
      });
    });
  }

  Future<List<MiniAccount>> _getSearch(String search) async {
    print("loading...:");
    http.Response response = await http.get(
        "http://192.168.0.18:8080/api/v1/search?query=$search",
        headers: {"Accept": "application/json"});
    print('URL= ' + response.request.url.toString());
    print(response.body);
    Map data = json.decode(response.body);
    List list = data as List;
    return list;
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => null;
}
