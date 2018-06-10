import 'package:flutter/material.dart';

abstract class ListItem {
  String first();
  String second();
  Widget leading();
}

class CustomTile extends StatelessWidget {
  final ListItem item;
  final VoidCallback onPressed;

  CustomTile({this.item, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        leading: item.leading(),
        title: new Text(
          item.first(),
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: new Text(item.second()),
        trailing: new IconButton(
            icon: new Icon(Icons.arrow_drop_down_circle),
            onPressed: onPressed),
    );
  }
}
