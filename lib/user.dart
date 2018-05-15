class User{
  String id;
  String instagram;
  String instaPassword;

  User({this.id, this.instagram, this.instaPassword});

  factory User.fromJson(Map<String, dynamic> json){
    return new User(
        id: json['id'],
        instagram: json['instagram'],
        instaPassword: json['instaPassword']);
  }
}