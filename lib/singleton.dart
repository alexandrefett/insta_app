import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_app/models.dart';

class Singleton {
  static final Singleton _singleton = new Singleton._internal();

  Profile profile;
  FirebaseUser fbuser;
  Account account;

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}