import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _db = Firestore.instance;

class WhiteListPage extends StatefulWidget {
  @override
  _WhiteListPage createState() => _WhiteListPage();
}

class _WhiteListPage extends State<WhiteListPage> with AutomaticKeepAliveClientMixin<WhiteListPage>{
  FirebaseUser _user = null;

  Widget _buildProgress(){
    return new Center(
        child: new CircularProgressIndicator());
  }

  @override
  void initState() {
   _auth.currentUser().then((user){
     _user = user;
   } );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('users')
          .document(_user.uid)
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

