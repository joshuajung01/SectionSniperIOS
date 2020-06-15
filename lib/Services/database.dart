import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference courseCollection = Firestore.instance.collection('users');

  Future updateNewUserData() async{
    return await courseCollection.document(uid).setData({
      'Open': ['OPEN 123 123'],
      'Current': ['CURR 123 123'],
      'Pending': ['PEND 123 123'],
      'Recent' : ['RCNT 123 123'],
      'Token' : 'token'
    });
  }




  //Add to Database
  Future addOpenCourse(String course) async{
    return await courseCollection.document(uid).updateData({
      'Open': FieldValue.arrayUnion([course])});
  }

  Future addCurrentCourse(String course) async{
    return await courseCollection.document(uid).updateData({
      'Current': FieldValue.arrayUnion([course])});
  }

  Future addPendingCourse(String course) async{
    return await courseCollection.document(uid).updateData({
      'Pending': FieldValue.arrayUnion([course])});
  }

  Future addRecentCourse(String course) async{
    return await courseCollection.document(uid).updateData({
      'Recent': FieldValue.arrayUnion([course])});
  }





  //Clear Database
  Future clearOpenCourse() async{
    return await courseCollection.document(uid).setData({
      'Open': [],
    });
  }

  Future clearCurrentCourse() async{
    return await courseCollection.document(uid).setData({
      'Current': [],
    });
  }

  Future clearPendingCourse() async{
    return await courseCollection.document(uid).setData({
      'Pending': [],
    });
  }

  Future clearRecentCourse() async{
    return await courseCollection.document(uid).setData({
      'Recent': [],
    });
  }

  Future clearAllCourses() async{
    return await courseCollection.document(uid).setData({
      'Open': [],
      'Current': [],
      'Pending': [],
      'Recent' : [],
      'Token' : ''
    });
  }


  //Remove Course from Database
  Future removeOpenCourse(String course) async{
    return await courseCollection.document(uid).updateData({
      'Open': FieldValue.arrayRemove([course])});
  }

  Future removeCurrentCourse(String course) async{
    return await courseCollection.document(uid).updateData({
      'Current': FieldValue.arrayRemove([course])});
  }

  Future removePendingCourse(String course) async{
    return await courseCollection.document(uid).updateData({
      'Pending': FieldValue.arrayRemove([course])});
  }

  Future removeRecentCourse(String course) async{
    return await courseCollection.document(uid).updateData({
      'Recent': FieldValue.arrayRemove([course])});
  }

  Future setToken(String token) async{
    return await courseCollection.document(uid).updateData({
      'Token' : token});
  }

  //Get data
  Future getOpenData() async {
    var doc = await courseCollection.document(uid).get();
    return doc.data['Open'];
  }

  Future getCurrentData() async {
    var doc = await courseCollection.document(uid).get();
    return doc.data['Current'];
  }

  Future getPendingData() async {
    var doc = await courseCollection.document(uid).get();
    return doc.data['Pending'];
  }

  Future getAllData() async {
    var doc = await courseCollection.document(uid).get();
    return doc.data;
  }


  //Get Data
  Stream<QuerySnapshot> get course{
    return courseCollection.snapshots();
  }

}