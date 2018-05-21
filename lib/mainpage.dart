import 'package:flutter/material.dart';
import 'package:insta_app/requestedpage2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainPageApp extends StatelessWidget {
  MainPageApp({this.firestore});

  final Firestore firestore;

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

  /// This controller can be used to programmatically
  /// set the current displayed page
  PageController _pageController;

  /// Indicating the current displayed page
  /// 0: trends
  /// 1: feed
  /// 2: community
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new PageView(
            children: [
              new SecondPage(),//Container(color: Colors.red),
              new Container(color: Colors.blue),
              new Container(color: Colors.grey)
            ],

            /// Specify the page controller
            controller: _pageController,
            onPageChanged: onPageChanged
        ),
        bottomNavigationBar: new BottomNavigationBar(
            items: [
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.add),
                  title: new Text("trends")
              ),
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.location_on),
                  title: new Text("feed")
              ),
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.people),
                  title: new Text("community")
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
        curve: Curves.ease
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
    _pageController = new PageController();
  }

  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
  }


}