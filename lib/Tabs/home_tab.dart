import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/Joshua/IdeaProjects/SectionSniper/lib/Models/course.dart';

class HomeTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeTabState();
  }
}

class _HomeTabState extends State<HomeTab>{
  List<Course> openCourses = [
    Course('MATH', 308, 511),
    Course('STAT', 211, 504),
    Course('CSCE', 121, 501),
    Course('PHYS', 216, 202),
    Course('MATH', 304, 509),
    Course('CSCE', 181, 500),
  ];

  List<Course> currentCourses = [
    Course('RAND', 123, 123),
    Course('RAND', 123, 123),
    Course('RAND', 123, 123),
    Course('RAND', 123, 123),
    Course('RAND', 123, 123),
    Course('RAND', 123, 123),
  ];

  Future<void> _addOpenClassToCurrent(String check){
    for(int i = 0; i < openCourses.length; i++){
      Course addingCourse = openCourses.elementAt(i);
      if(addingCourse.toString() == check){
        return showCupertinoDialog<void>(
            context: context,
            builder: (BuildContext context){
              return CupertinoAlertDialog(
                title: Text('Did you already sign-up for '+addingCourse.toString()+'?'),
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
                      currentCourses.add(Course(addingCourse.getDept(), addingCourse.getNum(), addingCourse.getSec()));
                      openCourses.removeAt(i);
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                  ),
                ],
              );
            }
          );
        }
      }
    }

  Future<void> _removeCurrentClass(String check) async{
    for(int i = 0; i < currentCourses.length; i++){
      Course removingCourse = currentCourses.elementAt(i);
      if(removingCourse.toString() == check){
        return showCupertinoDialog<void>(
            context: context,
            builder: (BuildContext context){
              return CupertinoAlertDialog(
                title: Text('Remove '+removingCourse.toString()+' from current courses?'),
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
                      currentCourses.removeAt(i);
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                  ),
                ],
              );
            }
          );
        }
      }
    }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
        child: CustomScrollView(
          slivers: <Widget>[

            CupertinoSliverNavigationBar(
              largeTitle: Text('Open Courses'),
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
                                            onPressed: (){_addOpenClassToCurrent(openCourses.elementAt(index).toString());},
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
                        onPressed: (){_removeCurrentClass(currentCourses.elementAt(index).toString());},
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
}