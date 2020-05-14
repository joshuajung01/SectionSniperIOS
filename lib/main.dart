/*
Section Sniper
5/8/2020
Joshua Jung
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:section_sniper/Services/auth.dart';
import 'package:section_sniper/wrapper.dart';
import 'Models/user.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user,
        child: CupertinoApp(
          home: Wrapper(),
        ),
    );
  }
}
