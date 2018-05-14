import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/model';
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

  int _offset = -1 * (new DateTime.now().millisecondsSinceEpoch);
  var cacheddata = new Map<int, Account>();
  var offsetLoaded = new Map<int, bool>();
  int _total = 0;

  @override
  void initState() {
    _getTotal().then((int total) {
      setState(() {
        _total = total;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var listView = new ListView.builder(
        itemCount: _total,
        itemBuilder: (BuildContext context, int index) {
          Account data = _getData(index);
             return new ListTile(
              title: new Text(data.fullName),
              //leading: new CircleAvatar(
              //  backgroundImage: new NetworkImage(data.profilePictureUrl),
              //),
              subtitle: new Text(data.username),
            );
         }
    );


    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Paged"),
      ),
      body: listView,
    );
  }


  Future<int> _getTotal() async {
    return 1;
  }

  void _updateDatas(int offset, List<Account> datas) {
    setState((){
      for (int i=0; i < datas.length; i++) {
        cacheddata.putIfAbsent(offset + i, () => datas[i]);
      }
      _total += datas.length;
    });
  }

  Future<List<Account>> _getRequested(int offset, int limit) async{
    print("loading...:");
    http.Response response = await http.get("http://192.168.0.25:4567/api/v1/requested?offset=$_offset&limit=20",
        headers: {
          "Accept":"application/json"
        }
    );
    print('URL= '+ response.request.url.toString());
    print(response.body);
    Map data = json.decode(response.body);

    StandardResponse dataAccount = new StandardResponse.fromJson(data);
    if(dataAccount.status=="SUCCESS") {
      List list = dataAccount.data as List;
      var datas = new List<Account>();
      list.forEach((element){
        Map map = element as Map;
        datas.add(Account.fromJson(map));
      });
      setState((){
        _offset = datas.elementAt(datas.length-1).date+1;
        print("offset:$_offset");
//        _total += datas.length;
      });
      return datas;
    }
    else {
      List<Account> list = new List<Account>();
      return list;
    }
  }

  Account _getData(int index) {
    Account data = cacheddata[index];
    if (data == null) {
      int offset = index ~/ 20 * 20;
      if (!offsetLoaded.containsKey(offset)) {
        offsetLoaded.putIfAbsent(offset, () => true);
        _getRequested(_offset, 20)
            .then((List<Account> datas) => _updateDatas(offset, datas));
      }
      data = new Account.loading();
    }
    return data;
  }
}

