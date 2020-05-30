import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class NotificationService{
  final FirebaseMessaging _fcm = FirebaseMessaging();
  bool _initialized = false;

  Future initialise() async{
    if(Platform.isIOS && !_initialized){
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


  saveDeviceToken() async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();

    String uid = user.uid;
    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      DatabaseService()
      await
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
