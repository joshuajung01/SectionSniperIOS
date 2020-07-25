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
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    List<Course> pendingCourses = [];
    List<Course> recentCourses = [];

    DatabaseService userDB = DatabaseService(uid: user.uid);

    return FutureBuilder(
      future: Future.wait([userDB.getPendingData(), userDB.getRecentData()]),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          pendingCourses = HomeScreen().convertStringToCourse(snapshot.data[0]);
          recentCourses = HomeScreen().convertStringToCourse(snapshot.data[1]);
          List<Course> reversedRecentCourses = recentCourses.reversed.toList();

          return SafeArea(
            top: true,
            child: CustomScrollView(
              slivers: <Widget>[

                CupertinoSliverNavigationBar(
                  largeTitle: Text('Wishlist Courses',),
                  heroTag: 'Wishlist Title',
                ),

                SliverFixedExtentList(
                  itemExtent: 50.0,
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      if (index > pendingCourses.length + 1) return null;

                      else if(index == pendingCourses.length){
                        if(index > 51 ){
                          return Card(
                            child: ListTile(
                              leading: Icon(CupertinoIcons.minus_circled,
                                color: Color.fromRGBO(50, 50, 50, 1),),
                              title: Text('Too Many Courses. Please remove '+(index - 51).toString()),
                            ),
                          );
                        }
                        else{
                          return Card(
                            child: ListTile(
                              leading: Icon(CupertinoIcons.minus_circled,
                                color: Color.fromRGBO(50, 50, 50, 1),),
                              title: Text('Searching for '+(index-1).toString() + ' courses.'),
                            ),
                          );
                        }
                      }

                      else if(index == pendingCourses.length + 1 || pendingCourses.length == 0){
                        return Card(
                          child: ListTile(
                            leading:  Icon(CupertinoIcons.add_circled,
                              color: Color.fromRGBO(50, 50, 50, 1),),
                            title: Text('Add Wishlist Course'),
                            onTap: (){
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          AddingCourse(category: 'Pending')));
                            },
                          ),
                        );
                      }
                      else{
                        return Card(
                          child: ListTile(
                            leading: Icon(CupertinoIcons.play_arrow_solid,
                              color: Color.fromRGBO(80, 0, 0, .85),),
                            title: Text(pendingCourses.elementAt(index).toString()),
                            trailing: IconButton(icon: Icon(CupertinoIcons.clear_circled),
                              color: Color.fromRGBO(80, 0, 0, .9),
                              onPressed: (){
                                userDB.removePendingCourse(pendingCourses.elementAt(index).toString());
                                if(recentCourses.length > 10){
                                  userDB.removeRecentCourse(recentCourses.elementAt(0).toString());
                                }
                                userDB.addRecentCourse(pendingCourses.elementAt(index).toString());
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),

                CupertinoSliverNavigationBar(
                  largeTitle: Text('Recent Courses',),
                  heroTag: 'Recent Title',
                ),

                SliverFixedExtentList(
                  itemExtent: 50.0,
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      if (index >= reversedRecentCourses.length && index != 0) return null;
                      else if(reversedRecentCourses.length == 0){
                        return Card(
                          child: ListTile(
                            leading: Icon(CupertinoIcons.time_solid,
                              color: Color.fromRGBO(80, 0, 0, .85),),
                            title: Text('No Recent Courses'),
                          ),
                        );
                      }
                      else{
                        return Card(
                          child: ListTile(
                            leading: Icon(CupertinoIcons.time_solid,
                              color: Color.fromRGBO(50, 50, 50, .6),),
                            title: Text(reversedRecentCourses.elementAt(index).toString()),
                            trailing: IconButton(icon: Icon(CupertinoIcons.add_circled,
                              color: Color.fromRGBO(80, 0, 0, .9),),
                              onPressed: (){
                                userDB.removeRecentCourse(reversedRecentCourses.elementAt(index).toString());
                                userDB.addPendingCourse(reversedRecentCourses.elementAt(index).toString());
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),

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
