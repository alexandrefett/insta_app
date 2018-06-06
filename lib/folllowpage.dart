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
  var data = List<Account>();
  var pageinfo = new PageInfo(hasNextPage: true, endCursor: "");
  var nextPage;
  //Follows page;

  Future<List<Account>> _getFollows(int id, PageInfo pageInfo) async {
    List<Account> datas = new List<Account>();
    String url = Endpoint.GET_FOLLOWS +
        '?id=$id&hasNext=${pageInfo.hasNextPage}&cursor=${pageInfo.endCursor}';
    Map map = await session.get(url);
    print(map);

    datas = data;
    List acc = map['data']['user']['edge_follow']['edges'] as List;
    acc.forEach((element) {
      print(element);
      Map node = element['node'];
      print(node);
      Account a = Account.fromInsta(node);
      print('-----1');
      datas.add(a);
      print('-----2');
    });
    nextPage =
        PageInfo.fromJson(map['data']['user']['edge_follow']['page_info']);
    return datas;
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Account>>(
        future: _getFollows(Singleton.instance.account.id, pageinfo),
        builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
          if (snapshot.hasData) {
            return createListView(context, snapshot);
           /* ListView.builder(
                itemCount: (snapshot.data == null) ? 0 : snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  print(index);
                  print(pageinfo.hasNextPage);
                  if (index == snapshot.data.length && pageinfo.hasNextPage) {
                    setState(() {
                      pageinfo = nextPage;
                      data = snapshot.data;
                    });
                  }
                  Account account = snapshot.data[index];
                  return new ListTile(title: new Text(account.username));
                });
                */
          } else {
            return _buildProgress;
          }
        });
  }

  Widget _buildProgress = new Center(child: new CircularProgressIndicator());

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Account> values = snapshot.data;
    return new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return new ListTile(
            title: new Text(values[index].username),
          );
        });
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
