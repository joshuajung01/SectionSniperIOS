class User {
  final String uid;
  bool isVerified;

  User({this.uid, this.isVerified});

  String getuid(){
    return uid;
  }

  bool getVerified(){
    return isVerified;
  }

}