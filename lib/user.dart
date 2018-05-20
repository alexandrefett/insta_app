class User{
  String id;
  String instagram;
  String instaPassword;
  String email;
  String password;
  String name;
  User({this.id, this.instagram, this.instaPassword, this.email, this.password, this.name});

  factory User.fromJson(Map<String, dynamic> json){
    return new User(
        id: json['id'],
        instagram: json['instagram'],
        instaPassword: json['instaPassword'],
        email: json['email'],
        name: json['name'],
        password: json['password']);
  }
}