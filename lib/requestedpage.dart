import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/models.dart';

class Requested2 extends StatelessWidget{
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
  int _total = 0;
  int _offset = -1 * (new DateTime.now().millisecondsSinceEpoch);
  var cachedaccount = new Map<int, Account>();
  var offsetLoaded = new Map<int, bool>();

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
  Widget build(BuildContext context){
    var listView = new ListView.builder(
      itemCount: _total,
        itemBuilder: (BuildContext context, int index){
          Account account = _getAccount(index);
          return new ListTile(
            title: new Text(account.username)
          );
        }
    );
    return new Scaffold(
      appBar:new AppBar(
          title: new Text("Requested Page")),
          body: listView
    );
  }

  Future<List<Account>> _getRequested(int offset, int limit) async{
    http.Response response = await http.get("http://10.125.121.64:4567/api/v1/requested?offset=$_offset&limit=$limit",
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
        _offset = datas.elementAt(datas.length-1).date;
        print("offset:$_offset");
      });
      return datas;
    }
    else {
      List<Account> list = new List<Account>();
      return list;
    }
  }

  Account _getAccount(int index){
    Account account = cachedaccount[index];
    if(account==null){
      int offset = _offset;
      if(!offsetLoaded.containsKey(offset)){
        offsetLoaded.putIfAbsent(offset, ()=> true);
        _getRequested(offset, 20)
            .then((List<Account> accounts) => _updateAccounts(offset, accounts));
      }
      account = new Account.loading();
    }
    return account;
  }

  Future<int> _getTotal() async{
    return 100;
  }

  void _updateAccounts(int offset, List<Account> accounts){
    setState(() {
      for(int i = 0;i<accounts.length;i++){
        cachedaccount.putIfAbsent(offset+1, () => accounts[i]);
      }

    });
  }
}

