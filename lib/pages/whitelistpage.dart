import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_app/models/listtile.dart';
import 'package:insta_app/models/models.dart';
import 'package:insta_app/singleton/singleton.dart';

class WhiteListPage extends StatefulWidget {
  @override
  _WhiteListPage createState() => _WhiteListPage();
}

class _WhiteListPage extends State<WhiteListPage>
    with AutomaticKeepAliveClientMixin<WhiteListPage> {
  FirebaseUser user;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser()
      .then((onValue) => user = onValue);
    super.initState();
  }

  Future<List<Account>> getData() async{
    var list = List<Account>();
    QuerySnapshot query = await Firestore.instance
        .collection('users')
        .document(Singleton.instance.firebaseUser.uid)
        .collection('followaccount')
        .getDocuments();

    query.documents.forEach((value){
      list.add(Account.fromDoc(value));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {

    Widget _buildProgress = new Center(
        child: new CircularProgressIndicator());

    return new FutureBuilder<List<Account>>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
        if (!snapshot.hasData) return _buildProgress;
        return new ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return new CustomTile(item: snapshot.data[index],onPressed: (){},);
          });
      }
    );
  }
  void _removeFromWhiteList(Account item) {
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('followaccount')
        .document(item.id.toString()).delete();
    }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
  }

