class Endpoint{
    static const DOMAIN_V1 = 'http://192.168.0.18:8080/api/v1';
    static const LOGIN = DOMAIN_V1 + '/login';
    static const GET_ACCOUNT = DOMAIN_V1 + '/account';
    static const GET_PROFILE = DOMAIN_V1 + '/profile';
}

class MiniAccount {
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

  MiniAccount.loading(){
    fullName = "Loading...";
  }

  MiniAccount({this.id, this.username, this.fullName, this.isVerified,
      this.followedByViewer, this.followsViewer, this.profilePicUrl, this.profilePicUrlHd,
      this.requestedByViewer, this.date});


  factory MiniAccount.fromJson(Map<String, dynamic> json){
    return new MiniAccount(
    id: json['id'],
    username: json['username'],
    fullName: json['fullName'],
    isVerified: json['isVerified'],
    followedByViewer: json['followedByViewer'],
    followsViewer: json['followsViewer'],
    profilePicUrl: json['profilePicUrl'],
    profilePicUrlHd: json['profilePicUrlHd'],
    requestedByViewer: json['requestedByViewer'],
    date: json['date']);
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

  factory Profile.fromJson(Map<String, dynamic> json){
    return new Profile(
        uid: json['uid'],
        username: json['username'],
        plan: json['plan'],
        password: json['password']);
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

  StandardResponse.fromJson(Map<String, dynamic> json){
    message = json['message'];
    status = json['status'];
    data = json['data'];
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