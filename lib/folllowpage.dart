import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/models.dart';
import 'package:insta_app/session.dart';

class FollowsPage extends StatefulWidget {
  @override
  _FollowsPage createState() => _FollowsPage();
}

class _FollowsPage extends State<FollowsPage>
    with AutomaticKeepAliveClientMixin<FollowsPage> {
  Session session = new Session();
  bool _isLoading = false;
  var data = List<Account>();
  var pageinfo = new PageInfo(hasNextPage: true, endCursor: "");
  var nextPage;
  //Follows page;

  Future<List<Account>> _getFollows(int id, PageInfo pageInfo) async {
    String url = Endpoint.GET_FOLLOWS +
        '?id=$id&hasNext=${pageInfo.hasNextPage}&cursor=${pageInfo.endCursor}';
    Map map = await session.get(url);
    print(url);
    print(map);
    List acc = map['data']['user']['edge_follow']['edges'] as List;
    acc.forEach((element) {
      Map node = element['node'];
      Account a = Account.fromInsta(node);
      data.add(a);
    });
    nextPage =
        PageInfo.fromJson(map['data']['user']['edge_follow']['page_info']);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Account>>(
        future: _getFollows(Singleton.instance.account.id, pageinfo),
        builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
          if (snapshot.connectionState==ConnectionState.done) {
            print(snapshot.connectionState);
            return createListView(context, snapshot);
          }
          else
            return _buildProgress;
        });
  }

  Future<void> _updatePage() async{
    new Future.delayed(new Duration(milliseconds: 300), ()
    {
      setState(() {
        pageinfo = nextPage;
      });
    });
  }

  Widget _buildProgress = new Center(
      child: new SizedBox(
          width: 18.0,
          height: 18.0,
          child: new CircularProgressIndicator()));

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Account> values = snapshot.data;
    return new ListView.builder(
        itemCount: pageinfo.hasNextPage ? values.length + 1: values.length,
        itemBuilder: (BuildContext context, int index) {
          print(index);
          if(index==values.length && pageinfo.hasNextPage){
            _updatePage();
            return _buildProgress;
          }
          return new ListTile(
            leading: new CircleAvatar(
              backgroundImage: new NetworkImage(values[index].profilePicUrl),
            ),
            title: new Text(
              values[index].username,
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: new Text(values[index].fullName),
            trailing: new FlatButton(
                onPressed: () {
                },
                child: new Text('Follow')),
          );
        });
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
