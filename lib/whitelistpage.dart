import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_app/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseUser user;

class WhiteListPage extends StatefulWidget {
  @override
  _WhiteListPage createState() => _WhiteListPage();
}

class _WhiteListPage extends State<WhiteListPage>
    with AutomaticKeepAliveClientMixin<WhiteListPage> {
  List<ListItem> _data = new List<ListItem>();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser()
        .then((onValue) => user = onValue);
  }
  @override
  Widget build(BuildContext context) {

    Widget _buildProgress = new Center(
        child: new CircularProgressIndicator());

    ListTile _tileAccount(DocumentSnapshot document) {
      Account account = Account.fromDoc(document);
      return new ListTile(
        leading: new CircleAvatar(
          backgroundImage: new NetworkImage(account.profilePicUrl),
        ),
        title: new Text(
          account.username,
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: new Text(account.fullName),
        trailing: new FlatButton(
            onPressed: () {
              _removeFromWhiteList(account);
            },
            child: new Text('Follow')),
      );
    };

    return new StreamBuilder<QuerySnapshot>(
      key: new PageStorageKey('List'),
      stream: Firestore.instance
          .collection('users')
          .document(Singleton.instance.account.id.toString())
          .collection('whitelist')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return _tileAccount(document);
          }).toList(),
        );
      },
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

