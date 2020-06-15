import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:section_sniper/Services/database.dart';

class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {},
        onLaunch: (Map<String, dynamic> message) async {},
        onResume: (Map<String, dynamic> message) async {},
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();

      final FirebaseAuth _auth = FirebaseAuth.instance;
      FirebaseUser user = await _auth.currentUser();
      DatabaseService _usersDB = DatabaseService(uid: user.uid);

      await _usersDB.setToken(token);

      _initialized = true;
    }
  }
}

//import 'dart:async';
//
//import 'package:flutter/cupertino.dart';
//import 'database.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//
//
//
//class MessageHandler{
//
//  final bool platform;
//
//  MessageHandler({this.platform});
//
//  final Firestore _db = Firestore.instance;
//  final FirebaseMessaging _fcm = FirebaseMessaging();
//
//  StreamSubscription iosSubscription;
//
//  void init(){
//    if (platform) {
//        iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
//        print(data);
//        saveDeviceToken();
//      });
//
//      _fcm.requestNotificationPermissions(IosNotificationSettings());
//    }
//    else {
//      saveDeviceToken();
//    }
//
//    _fcm.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print("onMessage: $message");
//
//        showCupertinoDialog(
//          builder: (context) => CupertinoAlertDialog(
//            title: Text(message['notification']['title']),
//            content: Text(message['notification']['body']),
//
//            actions: <Widget>[
//              CupertinoDialogAction(
//                child: Text('Ok'),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              ),
//            ],
//          ),
//        );
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print("onLaunch: $message");
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print("onResume: $message");
//      },
//    );
//  }
//
//  /// Get the token, save it to the database for current user
//  void saveDeviceToken() async {
//    // Get the current user
//    final FirebaseAuth _auth = FirebaseAuth.instance;
//    FirebaseUser user = await _auth.currentUser();
//
//    // Get the token for this device
//    String fcmToken = await _fcm.getToken();
//
//    // Save it to Firestore
//    if (fcmToken != null) {
//      DatabaseService db = DatabaseService(uid: user.uid);
//      await db.setToken(fcmToken);
//    }
//  }
//
//
//}
