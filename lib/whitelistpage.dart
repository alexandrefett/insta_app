import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;


class WhiteListPage extends StatefulWidget {
  @override
  _WhiteListPage createState() => _WhiteListPage();
}

class _WhiteListPage extends State<WhiteListPage> with AutomaticKeepAliveClientMixin<WhiteListPage>{

  Firestore firestore;
  var uid;

  Future<Firestore> connect() async{
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
    connect().then((Firestore firestore){
      this.firestore = firestore;
    });
    uid = _auth.currentUser().then((FirebaseUser user)=> uid = user.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('users')
          .document(uid)
          .collection('whitelist')
          .orderBy('date').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return new ListTile(
              leading: new CircleAvatar(child: new Image.network(document['profilePictureUrl'])),
              title: new Text(document['username']),
              subtitle: new Text(document['fullName']),
              trailing: new FlatButton(onPressed: (){}, child: new Text('Remover')),
            );
          }).toList(),
        );
      },
    );
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}

