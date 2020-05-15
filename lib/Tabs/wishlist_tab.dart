import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section_sniper/Models/user.dart';
import 'package:section_sniper/Services/database.dart';
import 'package:section_sniper/Services/loading.dart';
import 'package:section_sniper/home.dart';
import 'addingCourse.dart';
import '../Models/course.dart';

class WishlistTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WishlistTabState();
  }
}

class _WishlistTabState extends State<WishlistTab>{
//  List<Course> searchingCourses = [
//    Course('MATH', 308, 511),
//    Course('STAT', 211, 504),
//    Course('CSCE', 121, 501),
//    Course('PHYS', 216, 202),
//    Course('MATH', 304, 509),
//    Course('CSCE', 181, 500),
//  ];

  Future<void> _removePendingClass(String check, DatabaseService userDB) async{
    return showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: Text('Stop searching for \n'+check+'?'),
            content: Text('You can add it back later'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),

              CupertinoDialogAction(
                child: Text('Yes'),
                onPressed: () {
                  userDB.removePendingCourse(check);
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    List<Course> pendingCourses = [];

    DatabaseService userDB = DatabaseService(uid: user.uid);

    return FutureBuilder(
      future: userDB.getPendingData(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          pendingCourses = HomeScreen().convertStringToCourse(snapshot.data);

          return SafeArea(
            top: true,
            child: CustomScrollView(
              slivers: <Widget>[

                CupertinoSliverNavigationBar(
                  largeTitle: Text('Pending Courses',)
                ),
                SliverFixedExtentList(
                  itemExtent: 50.0,
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      if (index > pendingCourses.length) return null;
                      else if(index == pendingCourses.length || pendingCourses.length == 0){
                        return Card(
                          child: ListTile(
                            leading:  Icon(CupertinoIcons.add_circled_solid),
                            title: Text('Add Pending Course'),
                            onTap: (){
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          addingCourse(category: 'Pending')));
                            },
                          ),
                        );
                      }
                      else{
                        return Card(
                          child: ListTile(
                            leading: CupertinoActivityIndicator(),
                            title: Text(pendingCourses.elementAt(index).toString()),
                            trailing: IconButton(icon: Icon(CupertinoIcons.clear_circled),
                              onPressed: (){
                                _removePendingClass(pendingCourses.elementAt(index).toString(), userDB);
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),

//                SliverFixedExtentList(
//                  itemExtent: 50.0,
//                  delegate: SliverChildBuilderDelegate(
//                        (BuildContext context, int index) {
//                      if (index >= pendingCourses.length) return null;
//                      return Card(
//                        child: ListTile(
//                          leading: CupertinoActivityIndicator(),
//                          title: Text(pendingCourses.elementAt(index).toString()),
//                        trailing: IconButton(icon: Icon(CupertinoIcons.clear_circled),
//                                            color: CupertinoColors.systemRed,
//                                            onPressed: (){_removeSearchingClass(pendingCourses.elementAt(index).toString(), userDB);}
//                        ),
//                        ),
//                      );
//                    },
//                  ),
//                ),


              ],
            ),
          );
        }
        else{
          return Loading();
        }
      }
    );
  }
}
