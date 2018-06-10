import 'package:flutter/material.dart';
import 'package:insta_app/pages/folllowerspage.dart';
import 'package:insta_app/pages/folllowpage.dart';
import 'package:insta_app/pages/profilepage.dart';
import 'package:insta_app/pages/requestedpage2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_app/pages/searchpage.dart';
import 'package:insta_app/pages/whitelistpage.dart';

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
                child: new ProfilePage(),
              ),
              new Container(
                child: new SearchPage(),
              ),
              new Container(
                child: new WhiteListPage(),
              ),
              new Container(
                child: new FollowsPage()
              ),
              new Container(
                  child: new FollowersPage()
              )
            ],
            /// Specify the page controller
            controller: _pageController,
            onPageChanged: onPageChanged
        ),
        bottomNavigationBar: new BottomNavigationBar(
            items: [ new BottomNavigationBarItem(
                    icon: new Icon(Icons.account_circle, color: Colors.black54),
                    title: new Text("Profile", style: new TextStyle(color: Colors.black54))
              ),
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.search, color: Colors.black54),
                  title: new Text("Search", style: new TextStyle(color: Colors.black54))
              ),
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.star, color: Colors.black54),
                  title: new Text("Lists", style: new TextStyle(color: Colors.black54))
              ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.group, color: Colors.black54),
              title: new Text("Follows", style: new TextStyle(color: Colors.black54)),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.people_outline, color: Colors.black54),
              title: new Text("Followers", style: new TextStyle(color: Colors.black54)),
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