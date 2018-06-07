import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class Endpoint{
    static const DOMAIN_V1 = 'http://186.228.87.122:8080/api/v1';
    static const LOGIN = DOMAIN_V1 + '/login';
    static const GET_ACCOUNT = DOMAIN_V1 + '/account';
    static const GET_PROFILE = DOMAIN_V1 + '/profile';
    static const GET_SEARCH = DOMAIN_V1 + '/search';
    static const GET_FOLLOWS = DOMAIN_V1 + '/follows';
    static const GET_FOLLOWERS = DOMAIN_V1 + '/followers';
}

abstract class ListItem {}

class Singleton {
  static Singleton instance = new Singleton._();

  Account _account;
  FirebaseUser _firebaseUser;

  Singleton._();

  FirebaseUser get firebaseUser => _firebaseUser;

  set firebaseUser(FirebaseUser value) {
    _firebaseUser = value;
  }

  Account get account => _account;

  set account(Account value) {
    _account = value;
  }
}

class Follows {
  List<Account> nodes;
  int count;
  PageInfo pageInfo;

  Follows({this.nodes, this.count, this.pageInfo});

  factory Follows.fromJson(Map<String, dynamic> map){

    List data = map['data']['user']['edge_follow']['edges'] as List;
    print(data.length);
    List<Account> accounts = new List<Account>();

    data.forEach((node){
      print(node);
      Map element = node['node'];
      print(element);
      accounts.add(new Account(
        username: element['username'],
        fullName: element['full_name'],
        profilePicUrl: element['profile_pic_url'],
        id: element['id'],
        isVerified: element['is_verified'],
        followedByViewer: element['followed_by_viewer'],
        requestedByViewer: element['requested_by_viewer'],
      ));
    });
    return new Follows(
        nodes: accounts,
        count:map['data']['user']['edge_follow']['count'],
        pageInfo:PageInfo.fromJson(map['data']['user']['edge_follow']['page_info'])
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nodes': nodes,
      'count': count,
      'page_info': pageInfo.toMap()
    };
  }
}

class PageInfo{
  bool hasNextPage;
  String endCursor;

  PageInfo({this.hasNextPage, this.endCursor});

  factory PageInfo.fromJson(Map<String, dynamic> map){
    return new PageInfo(
        hasNextPage: map['has_next_page'],
        endCursor:map['end_cursor']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hasNextPage': hasNextPage,
      'endCursor': endCursor
    };
  }

}

class Search {
  int position;
  dynamic element;

  Search({this.position, this.element});

  factory Search.fromJson(Map<String, dynamic> map){
    return new Search(
        position: map['position'],
        element:map['element']
    );
  }
}

class HashTag implements ListItem{
  String name;
  int id;
  int mediaCount;

  HashTag({this.name, this.id, this.mediaCount});

  factory HashTag.fromJson(Map<String, dynamic> map){
    return new HashTag(
        name: map['name'],
        id: map['id'],
        mediaCount: map['media_count']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mediaCount': mediaCount
    };
  }

}

class Place  implements ListItem{
  String id;
  String title;
  String subtitle;
  String slug;
  List media;

  Place({this.id, this.title, this.subtitle, this.slug, this.media});

  factory Place.fromJson(Map<String, dynamic> map){
    Map<String, dynamic> location = map['location'];
    return new Place(
      id: location['pk'],
      title: map['title'],
      subtitle:map['subtitle'],
      slug:map['slug'],
      media:map['media'] as List
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'slug':slug
    };
  }
}

class Account implements ListItem{
  int id;
  String username;
  String fullName;
  bool isVerified;
  bool followedByViewer;
  bool followsViewer;
  String profilePicUrl;
  String profilePicUrlHd;
  bool requestedByViewer;
  int date;
  String biography;
  int followedBy;
  int follows;

  Account.loading(){
    fullName = "Loading...";
  }

  Account({this.biography, this.id, this.username, this.fullName, this.isVerified,
      this.followedByViewer, this.followsViewer, this.profilePicUrl, this.profilePicUrlHd,
      this.requestedByViewer, this.date, this.follows, this.followedBy});

  factory Account.fromJson(Map<String, dynamic> map){
    return new Account(
        biography: map['biography'],
        id: map['id'],
        username: map['username'],
        fullName: map['fullName'],
        isVerified: map['isVerified'],
        followedByViewer: map['followedByViewer'],
        followsViewer: map['followsViewer'],
        profilePicUrl: map['profilePicUrl'],
        profilePicUrlHd: map['profilePicUrlHd'],
        requestedByViewer: map['requestedByViewer'],
        date: map['date'],
        follows: map['follows'],
        followedBy: map['followedBy']
    );
  }
  factory Account.fromInsta(Map<String, dynamic> map){
    return new Account(
      username: map['username'],
      fullName: map['full_name'],
      profilePicUrl: map['profile_pic_url'],
      id: int.parse(map['id']),
      isVerified: map['is_verified'],
      followedByViewer: map['followed_by_viewer'],
      requestedByViewer: map['requested_by_viewer']
    );
  }

  factory Account.fromDoc(DocumentSnapshot map){
      return new Account(
          biography: map['biography'],
          id: map['id'],
          username: map['username'],
          fullName: map['fullName'],
          isVerified: map['isVerified'],
          followedByViewer: map['followedByViewer'],
          followsViewer: map['followsViewer'],
          profilePicUrl: map['profilePicUrl'],
          profilePicUrlHd: map['profilePicUrlHd'],
          requestedByViewer: map['requestedByViewer'],
          date: map['date'],
          follows: map['follows'],
          followedBy: map['followedBy']
      );
    }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'isVerified':isVerified,
      'followsViewer':followsViewer,
      'followedByViewer':followedByViewer,
      'profilePicUrl':profilePicUrl,
      'profilePicUrlHd':profilePicUrlHd,
      'requestedByViewer':requestedByViewer,
      'follows':follows,
      'followedBy':followedBy,
      'date':date
    };
  }
}

class Profile{
  String uid;
  String password;
  String username;
  var plan;

  Profile({this.uid, this.password, this.username, this.plan});

  factory Profile.fromJson(Map<String, dynamic> map){
    return new Profile(
        uid: map['uid'],
        username: map['username'],
        plan: map['plan'],
        password: map['password']);
  }

  factory Profile.fromDoc(DocumentSnapshot map){
    return new Profile(
        uid: map['uid'],
        username: map['username'],
        plan: map['plan'],
        password: map['password']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'plan': plan,
      'password': password
    };
  }
}

class StandardResponse {
  String message;
  String status;
  dynamic data;

  StandardResponse({this.message, this.status, this.data});

  StandardResponse.fromJson(Map<String, dynamic> map){
    message = map['message'];
    status = map['status'];
    data = map['data'];
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'status': status,
      'data': data
    };
  }
}

enum Plan {
  FREE, LIGHT, TOP
}