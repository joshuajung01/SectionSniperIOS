import 'package:flutter/cupertino.dart';
import 'package:section_sniper/Models/user.dart';
import 'package:section_sniper/Auth/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:section_sniper/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if(user == null || user.isVerified == false){
      return Authenticate();
    }
    else{
      return SectionSniper();
    }
  }
}
