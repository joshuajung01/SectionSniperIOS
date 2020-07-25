import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section_sniper/Models/course.dart';
import 'package:section_sniper/Models/user.dart';
import 'package:section_sniper/Services/database.dart';
import 'package:section_sniper/Services/loading.dart';
import 'package:section_sniper/home.dart';
import 'addingCourse.dart';

class HomeTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeTabState();
  }
}

class _HomeTabState extends State<HomeTab>{
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    List<Course> openCourses = [];
    List<Course> currentCourses = [];
    List<Course> recentCourses = [];

    DatabaseService userDB = DatabaseService(uid: user.uid);

    return FutureBuilder(
      future: Future.wait([userDB.getOpenData(), userDB.getCurrentData(), userDB.getRecentData()]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          openCourses = HomeScreen().convertStringToCourse(snapshot.data[0]);
          currentCourses = HomeScreen().convertStringToCourse(snapshot.data[1]);
          recentCourses = HomeScreen().convertStringToCourse(snapshot.data[2]);

          return SafeArea(
            top: true,
            child: CustomScrollView(
              slivers: <Widget>[

                CupertinoSliverNavigationBar(
                  heroTag: 'navBar1',
                  largeTitle: Text('Open Courses'),
                ),

                SliverFixedExtentList(
                  itemExtent: 50.0,
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      if (index >= openCourses.length) return null;
                      else{
                        return Card(
                          child: ListTile(
                            leading: Icon(CupertinoIcons.check_mark_circled_solid,
                              color: CupertinoColors.activeGreen,),
                            title: Text(openCourses.elementAt(index).toString()),
                            trailing: IconButton(icon: Icon(CupertinoIcons.add_circled),
                              color: Color.fromRGBO(80, 0, 0, 1),
                              onPressed: (){
                                String check = openCourses.elementAt(index).toString();
                                userDB.addCurrentCourse(check);
                                userDB.removeOpenCourse(check);
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
                  largeTitle: Text('Current Courses'),
                  transitionBetweenRoutes: true,
                ),

                SliverFixedExtentList(
                  itemExtent: 50.0,
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      if (index > currentCourses.length) return null;
                      else if(index == currentCourses.length || currentCourses.length == 0){
                        return Card(
                          child: ListTile(
                            leading:  Icon(CupertinoIcons.add_circled_solid,
                                color: Color.fromRGBO(80, 0, 0, .9),),
                            title: Text('Add Current Course'),
                            onTap: (){
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          AddingCourse(category: 'Current')));
                            },
                          ),
                        );
                      }
                      else{
                        return Card(
                          child: ListTile(
                            leading: Icon(CupertinoIcons.check_mark_circled_solid,
                              color: Color.fromRGBO(80, 0, 0, .9),),
                            title: Text(currentCourses.elementAt(index).toString()),
                            trailing: IconButton(icon: Icon(CupertinoIcons.clear_circled),
                              color: Color.fromRGBO(80, 0, 0, 1),
                              onPressed: (){
                              String check = currentCourses.elementAt(index).toString();
                              userDB.removeCurrentCourse(check);
                              if(recentCourses.length >= 10){
                                userDB.removeRecentCourse(recentCourses.elementAt(0).toString());
                              }
                              userDB.addRecentCourse(check);
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
      },
    );
  }
}






