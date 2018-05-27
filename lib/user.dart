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