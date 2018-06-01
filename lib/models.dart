import 'dart:convert';

class Endpoint{
    static const DOMAIN_V1 = 'http://186.228.87.122:8080/api/v1';
    static const LOGIN = DOMAIN_V1 + '/login';
    static const GET_ACCOUNT = DOMAIN_V1 + '/account';
    static const GET_PROFILE = DOMAIN_V1 + '/profile';
    static const GET_SEARCH = DOMAIN_V1 + '/search';
}
abstract class ListItem {}
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