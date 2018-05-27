import 'user.dart';
class Singleton {
  static final Singleton _singleton = new Singleton._internal();

  User user;

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}