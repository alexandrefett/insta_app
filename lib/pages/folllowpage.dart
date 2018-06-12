import 'dart:async';
import 'package:flutter/material.dart';
import 'package:insta_app/models/listtile.dart';
import 'package:insta_app/models/models.dart';
import 'package:insta_app/singleton/session.dart';
import 'package:insta_app/singleton/singleton.dart';

class FollowsPage extends StatefulWidget {
  @override
  _FollowsPage createState() => _FollowsPage();
}

class _FollowsPage extends State<FollowsPage>
    with AutomaticKeepAliveClientMixin<FollowsPage> {
  bool _isLoading = false;
  var data = List<Account>();
  var pageinfo = new PageInfo(hasNextPage: true, endCursor: "");
  var nextPage;
  //Follows page;

  Future<List<Account>> _getFollows(int id, PageInfo pageInfo) async {
    String url = Session.GET_FOLLOWS +
        '?id=$id&hasNext=${pageInfo.hasNextPage}&cursor=${pageInfo.endCursor}';
    Map map = await Session.instance.get(url);
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
          print(_isLoading);
          print(snapshot.connectionState);
          if(snapshot.connectionState==ConnectionState.waiting){
            _isLoading = true;
          }
          if(snapshot.connectionState==ConnectionState.done){
            _isLoading = false;
          }
          if (snapshot.hasData) {
            return createListView(context, snapshot);
          }
          else
            return _buildProgress;
        });
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Account> values = snapshot.data;
    return new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          if(index==values.length-1 && pageinfo.hasNextPage && !_isLoading){
            _updatePage();
            return _buildProgress;
          }
          return new CustomTile(item: values[index],onPressed: (){});
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

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
