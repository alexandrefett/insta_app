import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_app/models/models.dart';
import 'package:insta_app/singleton/session.dart';

class Singleton {
  static Singleton instance = new Singleton._();
  Profile _profile;
  Account _account;
  FirebaseUser _firebaseUser;

  Singleton._();

  Profile get profile => _profile;
  set profile(Profile value) {
    Firestore.instance
        .collection('profile')
        .document(profile.uid)
        .setData(profile.toMap());
    _profile = value;
  }

  FirebaseUser get firebaseUser => _firebaseUser;
  set firebaseUser(FirebaseUser value) {
    _firebaseUser = value;
  }

  Account get account => _account;
  set account(Account value) {
    _account = value;
  }

  Future<Profile> currentProfile() async {
    if (profile == null) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      DocumentSnapshot doc = await Firestore.instance
          .collection('profile')
          .document(user.uid)
          .get();
      if (!doc.exists) return null; //throw Error();
      profile = Profile.fromDoc(doc);
      return profile;
    } else
      return _profile;
  }
}
