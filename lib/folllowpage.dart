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
    with AutomaticKeepAliveClientMixin<FollowsPage>{

  Session session = new Session();
  var _data = List<Account>();
  var _pageinfo = new PageInfo(hasNextPage: true, endCursor: null);

  Future<List<Account>> _getFollows(int id, PageInfo pageInfo) async{
    Follows page;
    String url = Endpoint.GET_FOLLOWS + '?id=$id&hasNext=${pageInfo.hasNextPage}&cursor=${pageInfo.endCursor}';
    Map map = await session.get(url);
/*    http.Response response = await http.get(Endpoint.GET_FOLLOWS + '?id=$id&hasNext=${pageInfo.hasNextPage}&cursor=${pageInfo.endCursor}',
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json"
        });

    print(response.body);
    */
    page = Follows.fromJson(map);
    setState(() {
      _pageinfo = page.pageInfo;
      _data.addAll(page.nodes);
    });
    return _data;
  }

  
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Account>>(
        future: _getFollows(Singleton.instance.account.id, _pageinfo),
        builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return new ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
              Account account = snapshot.data[index];
              return new ListTile(
                  title: new Text(account.username)
              );
            });
          }
          else {
            return _buildProgress;
          }
        });
  }

  Widget _buildProgress = new Center(
      child: new CircularProgressIndicator());

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;

}

