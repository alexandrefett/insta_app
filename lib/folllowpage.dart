import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowsPage extends StatefulWidget {
  @override
  _FollowsPage createState() => _FollowsPage();
}

class _FollowsPage extends State<FollowsPage>
    with AutomaticKeepAliveClientMixin<FollowsPage>{

  var _data = List<Account>();
  var _page;

  Future<List<Account>> _getFollows() async{
    http.Response response = await http.get(Endpoint.GET_FOLLOWS,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json"
        },
        body: data);

    _data
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<Account>(
        future: _getFollows(),
        builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return new ListView(
                children: snapshot.data((Account document) {
              return new ListTile(
                title: new Text(document.username),
                subtitle: new Text(document.fullName),
              );
            }).toList();
          }
          else {
            return _buildProgress();
          }
        });
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}

