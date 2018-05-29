class Account {
  int id;
  String username;
  String fullName;
  bool isVerified;
  bool followedByViewer;
  bool followsViewer;
  String profilePictureUrl;
  bool requestedByViewer;
  int date;

  Account.loading(){
    fullName = "Loading...";
  }

  Account({this.id, this.username, this.fullName, this.isVerified,
      this.followedByViewer, this.followsViewer, this.profilePictureUrl,
      this.requestedByViewer, this.date});


  factory Account.fromJson(Map<String, dynamic> json){
    return new Account(
    id: json['id'],
    username: json['username'],
    fullName: json['fullName'],
    isVerified: json['isVerified'],
    followedByViewer: json['followedByViewer'],
    followsViewer: json['followsViewer'],
    profilePictureUrl: json['profilePictureUrl'],
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
      'profilePictureUrl':profilePictureUrl,
      'requestedByViewer':requestedByViewer,
      'date':date
    };
  }
}

class User{
  String password;
  String username;
  User({this.password, this.username});

  factory User.fromJson(Map<String, dynamic> json){
    return new User(
        username: json['username'],
        password: json['password']);
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
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
