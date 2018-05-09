import 'package:flutter/material.dart';

class Requested extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:new AppBar(title: new Text("Requested"),),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            children:<Widget>[
              new Text("Second")
            ]
          ),
      )
    ),
    );
  }
}