import 'package:flutter/material.dart';
import 'package:insta_app/requestedpage2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'InstaManager',
      home: new MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {

  SecondPage secondPage = new SecondPage();
  PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("InstaManager"),
          centerTitle: true,
        ),
        body:
        new PageView(
            children: [
              new Container(
                key: new PageStorageKey('Profile'),
                child: secondPage,//Container(color: Colors.red),
              ),
              new Container(
                color: Colors.blue,
                key: new PageStorageKey('Search')
              ),
              new Container(
                  color: Colors.grey,
                  key: new PageStorageKey('List')
              ),
              new Container(
                  color: Colors.yellow,
                  key: new PageStorageKey('Follow'))
            ],
            /// Specify the page controller
            controller: _pageController,
            onPageChanged: onPageChanged
        ),
        bottomNavigationBar: new BottomNavigationBar(
            items: [ new BottomNavigationBarItem(
                    icon: new Icon(Icons.account_circle, color: Colors.black54),
                    title: new Text("Profile")
              ),
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.search, color: Colors.black54),
                  title: new Text("Search")
              ),
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.list, color: Colors.black54),
                  title: new Text("Lists")
              ),
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.group, color: Colors.black54),
                  title: new Text("Follow"),
              )
            ],

            /// Will be used to scroll to the next page
            /// using the _pageController
            onTap: navigationTapped,
            currentIndex: _page
        )
    );
  }

  /// Called when the user presses on of the
  /// [BottomNavigationBarItem] with corresponding
  /// page index
  void navigationTapped(int page){

    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,

    );
  }


  void onPageChanged(int page){
    setState((){
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(keepPage:true);
  }

  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
  }


}