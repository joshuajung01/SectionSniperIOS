import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:section_sniper/Models/course.dart';
import 'package:section_sniper/Models/user.dart';
import 'package:section_sniper/Services/database.dart';
import 'package:section_sniper/Services/loading.dart';
import 'package:section_sniper/home.dart';

class HomeTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeTabState();
  }
}

class _HomeTabState extends State<HomeTab>{
  Future<void> _addOpenClassToCurrent(String check, DatabaseService userDB){
    return showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: Text('Did you already sign-up for '+check+'?'),
            content: Text('The course will be moved to \n\'Current Courses\''),
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
                  userDB.addCurrentCourse(check);
                  userDB.removeOpenCourse(check);
//                  currentCourses.add(Course(addingCourse.getDept(), addingCourse.getNum(), addingCourse.getSec()));
//                  openCourses.removeAt(i);
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
            ],
          );
        }
      );
    }
    Future<void> _removeCurrentClass(String check, DatabaseService userDB) async{
      return showCupertinoDialog<void>(
          context: context,
          builder: (BuildContext context){
            return CupertinoAlertDialog(
              title: Text('Remove '+check+' from current courses?'),
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
                    userDB.removeCurrentCourse(check);
//                    currentCourses.removeAt(i);
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
              ],
            );
          }
        );
      }

//  Future<void> _addOpenClassToCurrent(String check, openCourses, currentCourses){
//    for(int i = 0; i < openCourses.length; i++){
//      Course addingCourse = openCourses.elementAt(i);
//      if(addingCourse.toString() == check){
//        return showCupertinoDialog<void>(
//            context: context,
//            builder: (BuildContext context){
//              return CupertinoAlertDialog(
//                title: Text('Did you already sign-up for '+addingCourse.toString()+'?'),
//                content: Text('The course will be moved to \n\'Current Courses\''),
//                actions: <Widget>[
//                  CupertinoDialogAction(
//                    child: Text('No'),
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                      setState(() {});
//                    },
//                  ),
//
//                  CupertinoDialogAction(
//                    child: Text('Yes'),
//                    onPressed: () {
//                      currentCourses.add(Course(addingCourse.getDept(), addingCourse.getNum(), addingCourse.getSec()));
//                      openCourses.removeAt(i);
//                      Navigator.of(context).pop();
//                      setState(() {});
//                    },
//                  ),
//                ],
//              );
//            }
//          );
//        }
//      }
//    }

//  Future<void> _removeCurrentClass(String check, currentCourses) async{
//    for(int i = 0; i < currentCourses.length; i++){
//      Course removingCourse = currentCourses.elementAt(i);
//      if(removingCourse.toString() == check){
//        return showCupertinoDialog<void>(
//            context: context,
//            builder: (BuildContext context){
//              return CupertinoAlertDialog(
//                title: Text('Remove '+removingCourse.toString()+' from current courses?'),
//                content: Text('You can add it back later'),
//                actions: <Widget>[
//                  CupertinoDialogAction(
//                    child: Text('No'),
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                      setState(() {});
//                    },
//                  ),
//
//                  CupertinoDialogAction(
//                    child: Text('Yes'),
//                    onPressed: () {
//                      currentCourses.removeAt(i);
//                      Navigator.of(context).pop();
//                      setState(() {});
//                    },
//                  ),
//                ],
//              );
//            }
//          );
//        }
//      }
//    }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    List<Course> openCourses = [];
    List<Course> currentCourses = [];

    DatabaseService userDB = DatabaseService(uid: user.uid);

//    smile.getOpenData().then((value){
//      openCourses =  HomeScreen().convertStringToCourse(value);
//      setState(() {});
//      print(openCourses);
//    });

//    print(user.uid);
//    smile.getOpenData().then((value){
//      print(value[0]);
//      prelimOpenCourses = value;
//    });
//
//    print('1');
//    print(prelimOpenCourses);

//            FutureBuilder(
//              future: smile.getOpenData(),
//              builder: (context, snapshot){
//                if(snapshot.connectionState == ConnectionState.done){
//                  openCourses = HomeScreen().convertStringToCourse(snapshot.data);
//                  return null;
//                }
//                else{
//                  return CupertinoActivityIndicator();
//                }
//              },
//            ),

    return FutureBuilder(
      future: Future.wait([userDB.getOpenData(), userDB.getCurrentData()]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          openCourses = HomeScreen().convertStringToCourse(snapshot.data[0]);
          currentCourses = HomeScreen().convertStringToCourse(snapshot.data[1]);

          return SafeArea(
            top: true,
            child: CustomScrollView(
              slivers: <Widget>[

                CupertinoSliverNavigationBar(
                  largeTitle: Text('Open Courses'),
                  trailing: CupertinoButton(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(CupertinoIcons.refresh),
                    ),
                    onPressed: (){setState(() {});},
                  ),
                ),


                SliverFixedExtentList(
                  itemExtent: 50.0,
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      if (index >= openCourses.length) return null;
                      return Card(
                        child: ListTile(
                          leading: Icon(CupertinoIcons.check_mark_circled_solid,
                            color: CupertinoColors.activeGreen,),
                          title: Text(openCourses.elementAt(index).toString()),
                          trailing: IconButton(icon: Icon(CupertinoIcons.add_circled),
                            onPressed: (){_addOpenClassToCurrent(openCourses.elementAt(index).toString(), userDB);},
                          ),
                        ),
                      );
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
                      if (index >= currentCourses.length) return null;
                      return Card(
                        child: ListTile(
                          leading: Icon(CupertinoIcons.check_mark_circled_solid,),
                          title: Text(currentCourses.elementAt(index).toString()),
                          trailing: IconButton(icon: Icon(CupertinoIcons.clear_circled),
                            onPressed: (){_removeCurrentClass(currentCourses.elementAt(index).toString(), userDB);},
                          ),
                        ),
                      );
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

//    return SafeArea(
//      top: true,
//        child: CustomScrollView(
//          slivers: <Widget>[
//
//            CupertinoSliverNavigationBar(
//              largeTitle: Text('Open Courses'),
//            ),
//
//
//            SliverFixedExtentList(
//              itemExtent: 50.0,
//              delegate: SliverChildBuilderDelegate(
//                    (BuildContext context, int index) {
//                  if (index >= openCourses.length) return null;
//                    return Card(
//                      child: ListTile(
//                        leading: Icon(CupertinoIcons.check_mark_circled_solid,
//                          color: CupertinoColors.activeGreen,),
//                        title: Text(openCourses.elementAt(index).toString()),
//                        trailing: IconButton(icon: Icon(CupertinoIcons.add_circled),
//                          onPressed: (){_addOpenClassToCurrent(openCourses.elementAt(index).toString(), openCourses, currentCourses);},
//                        ),
//                      ),
//                    );
//                },
//              ),
//            ),


//            FutureBuilder(
//              future: smile.getOpenData(),
//              builder: (context, snapshot){
//                if(snapshot.connectionState == ConnectionState.done){
//                  openCourses = HomeScreen().convertStringToCourse(snapshot.data);
//                  return null;
//                }
//                else{
//                  return CupertinoActivityIndicator();
//                }
//              },
//            ),

//            CupertinoSliverNavigationBar(
//              largeTitle: Text('Current Courses'),
//              transitionBetweenRoutes: true,
//            ),
//
//            SliverFixedExtentList(
//              itemExtent: 50.0,
//              delegate: SliverChildBuilderDelegate(
//                    (BuildContext context, int index) {
//                  if (index >= currentCourses.length) return null;
//                  return Card(
//                    child: ListTile(
//                      leading: Icon(CupertinoIcons.check_mark_circled_solid,),
//                      title: Text(currentCourses.elementAt(index).toString()),
//                      trailing: IconButton(icon: Icon(CupertinoIcons.clear_circled),
//                        onPressed: (){_removeCurrentClass(currentCourses.elementAt(index).toString(), currentCourses);},
//                      ),
//                    ),
//                  );
//                },
//              ),
//            ),
//
//          ],
//      ),
//    );
  }
}