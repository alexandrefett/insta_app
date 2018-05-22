import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/model';
import 'package:insta_app/standardresponse.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<String> _getProfile(String username) async{
  http.Response response = await http.get("http://10.125.121.64:4567/api/v1/user/$username",
      headers: {
        "Accept":"application/json"
      }
  );
  print('URL= '+ response.request.url.toString());
  print(response.body);
  Map data = json.decode(response.body);

  StandardResponse dataAccount = new StandardResponse.fromJson(data);
}


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage>{

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
    firestore = new Firestore(app: app);
  }

  @override
  void initState() {
    connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container();
  }

}

