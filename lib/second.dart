import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/standardresponse.dart';

class Requested extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        title: 'Requested',
        theme: new ThemeData(
            primarySwatch: Colors.blue
        ),
        home: new SecondPage()
    );
  }
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPage createState() => _SecondPage();
}

class _SecondPage extends State<SecondPage>{
  int _total = 3;

  @override
  Widget build(BuildContext context){
    var listView = new ListView.builder(
      itemCount: _total,
        itemBuilder: (BuildContext context, int index){
          return new ListTile(
            title: new Text("Item")
          );
        }
    );
    return new Scaffold(
      appBar:new AppBar(title: new Text("Requested"),
      ),
      body: listView
    );
  }
}

Future<String> _getRequested(int offset, int limit) async{
  http.Response response = await http.get("http://10.125.121.64:4567/api/v1/requested?offset=$offset&limit=$limit",
      headers: {
        "Accept":"application/json"
      }
  );
  print(response.body);

  Map data = json.decode(response.body);
  var dataAccount = new StandardResponse.fromJson(data);
}
