import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_app/models/models.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPage createState() => _SecondPage();
}

class _SecondPage extends State<SecondPage> with AutomaticKeepAliveClientMixin<SecondPage>{

  Firestore firestore;

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


  int _offset = -1 * (new DateTime.now().millisecondsSinceEpoch);
  var cacheddata = new Map<int, Account>();
  var offsetLoaded = new Map<int, bool>();
  int _total = 0;


  @override
  void initState() {
    connect().then((Firestore firestore){
      this.firestore = firestore;
    });
    _getTotal().then((int total) {
      setState(() {
        _total = total;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
      key: new PageStorageKey('List'),
      stream: firestore
          .collection('users')
          .document('3472751680')
          .collection('requested')
          .orderBy('date').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return new ListTile(
              title: new Text(document['username']),
              subtitle: new Text(document['fullName']),
            );
          }).toList(),
        );
      },
    );
  }

  Future<int> _getTotal() async {
    return 1;
  }

  void _updateDatas(int offset, List<Account> datas) {
    setState((){
      for (int i=0; i < datas.length; i++) {
        cacheddata.putIfAbsent(offset + i, () => datas[i]);
      }
      _total += datas.length;
    });
  }

  Future<List<Account>> _getRequested(int offset, int limit) async{
    print("loading...:");

    CollectionReference ref = Firestore.instance
        .collection('users')
        .document('userid')
        .collection('requested')
        .orderBy('date')
        .startAt([offset])
        .limit(limit);

    http.Response response = await http.get("http://192.168.0.25:4567/api/v1/requested?offset=$_offset&limit=20",
        headers: {
          "Accept":"application/json"
        }
    );
    print('URL= '+ response.request.url.toString());
    print(response.body);
    Map data = json.decode(response.body);

      List list = data['data'] as List;
      var datas = new List<Account>();
      list.forEach((element){
        Map map = element as Map;
        datas.add(Account.fromJson(map));
      });
      setState((){
        _offset = datas.elementAt(datas.length-1).date+1;
        print("offset:$_offset");
//        _total += datas.length;
      });
      return datas;
  }

  Account _getData(int index) {
    Account data = cacheddata[index];
    if (data == null) {
      int offset = index ~/ 20 * 20;
      if (!offsetLoaded.containsKey(offset)) {
        offsetLoaded.putIfAbsent(offset, () => true);
        _getRequested(_offset, 20)
            .then((List<Account> datas) => _updateDatas(offset, datas));
      }
      data = new Account(username: "Loading...");
    }
    return data;
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}

