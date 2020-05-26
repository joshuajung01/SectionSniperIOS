import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class notificationService{
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async{
    if(Platform.isIOS){
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async{
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async{
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async{
        print('onResume: $message');
      },

    );
  }
}




//class messageHandler extends StatefulWidget {
//  @override
//  _messageHandlerState createState() => _messageHandlerState();
//}
//
//class _messageHandlerState extends State<messageHandler> {
//  final Firestore _db = Firestore.instance;
//  final FirebaseMessaging _fcm = FirebaseMessaging();
//
//  StreamSubscription iosSubscription;
//
//  @override
//  void initState() {
//    super.initState();
//    if (Platform.isIOS) {
//      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
//        // save the token  OR subscribe to a topic here
//      });
//
//      _fcm.requestNotificationPermissions(IosNotificationSettings());
//    }
//
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}
