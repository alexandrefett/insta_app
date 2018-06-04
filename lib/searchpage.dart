import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseUser user;

class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  List<ListItem> _data = new List<ListItem>();
  bool _isLoading = false;
  final TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser()
        .then((onValue) => user = onValue);
  }
  @override
  Widget build(BuildContext context) {

    Widget _buildProgress = new SliverFillRemaining(
        child: new Center(
            child: new CircularProgressIndicator()));

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
            style: new TextStyle(
                fontStyle: FontStyle.italic, color: Colors.black),),),
        title: new Text(
          '#' + hashTag.name,
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
            child: const Icon(Icons.place, color: Colors.black,)),
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

    ListTile _buildTile(ListItem item){
      if (item is Account) {
        return _tileAccount(item);
      }
      if (item is HashTag) {
        return _tileHashTag(item);
      }
      if (item is Place) {
        return _tilePlace(item);
      }
    };

    SliverList _buildSliverList = new SliverList(
        delegate: new SliverChildBuilderDelegate(
                (context, index) => _buildTile(_data[index]),
                childCount: _data == null ? 0 : _data.length));

      return new CustomScrollView (
        slivers: <Widget>[
          new SliverAppBar(
            expandedHeight: 55.0,
            floating: true,
            pinned: false,
            leading: new Icon(Icons.search),
            actions: <Widget>[
              new IconButton(
                icon: new Icon(Icons.cancel),
                onPressed: () { _clear(); },
              )
            ],
            title: new TextField(
                maxLines: 1,
                maxLength: 20,
                keyboardType: TextInputType.text,
                controller: _controller,
                onSubmitted: (String value) {
                  _search(value);
                },
              style: new TextStyle(color: Colors.white, fontSize: 22.0),
              )),
          _isLoading ? _buildProgress : _buildSliverList,
        ]
    );
  }

  void _addToFollow(ListItem item) {
    DocumentReference _db =
      Firestore.instance
          .collection('users')
          .document(user.uid);
    if (item is Account) {
      _db.collection('followaccount')
          .document(item.id.toString()).setData(item.toMap());
    }
    if (item is HashTag) {
      _db.collection('followhashtag')
          .document(item.id.toString()).setData(item.toMap());

    }
    if (item is Place) {
      _db.collection('followplace')
          .document(item.id.toString()).setData(item.toMap());

    }
  }

  void _clear(){
    _controller.clear();
    setState(() {
      _data.clear();
    });
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
