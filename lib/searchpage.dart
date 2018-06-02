import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  List<ListItem> _data = new List<ListItem>();
  var search;
  bool _isLoading = false;
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget _buildProgress = new Center(child: new CircularProgressIndicator());

    Widget _buildSearch = new Container(
        decoration: new BoxDecoration(color: Colors.blue),
        child: new Row(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        new Flexible(
          child: new TextField(controller: _controller,
              decoration: new InputDecoration(
                  hintText: "search",
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                    borderSide: new BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  )),
            keyboardType: TextInputType.text,
            onChanged: (String value) {
              this.search = value;
            })),
        new IconButton(color: Colors.grey,
                icon: new Icon(Icons.clear,color: Colors.black),
                onPressed: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _controller.clear();
                  setState(() {
                    _data.clear();
                  });
                }),
        new IconButton(color: Colors.blue,
                icon: new Icon(Icons.search,color: Colors.black),
                onPressed: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _search(this.search);
                })

      ],
    ));

    ListTile _tileAccount(Account account) {
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
              _addToFollow(account);
            },
            child: new Text('Follow')),
      );
    };

    ListTile _tileHashTag(HashTag hashTag) {
      return new ListTile(
        leading: new CircleAvatar(
          backgroundColor: Colors.black12,
          child: new Text(
            '#',
            style: new TextStyle(fontStyle: FontStyle.italic,color: Colors.black),),),
        title: new Text(
          '#'+ hashTag.name,
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: new Text('Count: ${hashTag.mediaCount}'),
        trailing: new FlatButton(
            onPressed: () {
              _addToFollow(hashTag);
            },
            child: new Text('Follow')),
      );
    };

    ListTile _tilePlace(Place place) {
      return new ListTile(
        leading: new CircleAvatar(
          backgroundColor: Colors.black12,
          child: const Icon(Icons.place,color: Colors.black,)),
        title: new Text(
          place.title,
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: new Text(place.subtitle),
        trailing: new FlatButton(
            onPressed: () {
              _addToFollow(place);
            },
            child: new Text('Follow')),
      );
    };

    Widget _buildList = new ListView.builder(
        itemCount: _data == null ? 0 : _data.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _data[index];
          print(item);
          if (item is Account) {
            return _tileAccount(item);
          }
          if (item is HashTag) {
            return _tileHashTag(item);
          }
          if (item is Place) {
            return _tilePlace(item);
          }
        });

    return new Container(
        padding: new EdgeInsets.all(5.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[_buildSearch,
              /*new ListTile(title: new TextField(
                    decoration: new InputDecoration(
                        hintText: "search",
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(2.0),
                          ),
                          borderSide: new BorderSide(
                            color: Colors.black,
                            width: 10.0,
                          ),
                        )),
                    onChanged: (String value) {
                      this.search = value;
                    },
                  ),
                  trailing: new FlatButton(
                      child: new IconButton(
                          onPressed: () { _search(this.search);},
                          color: Colors.blue,
                          icon: new Icon(Icons.search, color: Colors.black,)))),*/
              new Expanded(child: _isLoading ? _buildProgress : _buildList)
            ]));
  }

  void _addToFollow(dynamic follow) {
    print(follow);
  }

  Future<String> _search(String search) async {
    setState(() {
      _isLoading = true;
    });
    http.Response response = await http.get(
        Endpoint.GET_SEARCH + '?query=$search',
        headers: {"Accept": "application/json"});
    print(response.body);
    Map map = json.decode(response.body);
    List accounts = map['users'] as List;
    List places = map['places'] as List;
    List hashtags = map['hashtags'] as List;

    var datas = new List<Search>();

    accounts.forEach((element) {
      Map map = element as Map;
      Map temp = map['user'];
      int position = map['position'];
      datas.add(
          new Search(
              position: position,
              element: new Account(
                profilePicUrl: temp['profile_pic_url'],
                fullName:temp['full_name'],
                followedBy: temp['follower_count'],
                id: int.parse(temp['pk']),
                isVerified: temp['is_verified'],
                username: temp['username']
      )));
    });

    hashtags.forEach((element) {
      map = element as Map;
      Map temp = map['hashtag'];
      int position = map['position'];
      datas.add(new Search(position: position, element: HashTag.fromJson(temp)));
    });

    places.forEach((element) {
      map = element as Map;
      Map temp = map['place'];
      int position = map['position'];
      Map location = temp['location'];
      datas.add(new Search(position: position, element: Place.fromJson(temp)));
    });

    datas.sort((a, b) => a.position.compareTo(b.position));
    _data.clear();
    setState(() {
      datas.forEach((search){
        _data.add(search.element);
      });
      _isLoading = false;
    });
    return 'Success!';
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
