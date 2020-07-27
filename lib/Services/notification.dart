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