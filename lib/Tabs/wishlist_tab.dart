import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/course.dart';

class WishlistTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WishlistTabState();
  }
}

class _WishlistTabState extends State<WishlistTab>{
  List<Course> searchingCourses = [
    Course('MATH', 308, 511),
    Course('STAT', 211, 504),
    Course('CSCE', 121, 501),
    Course('PHYS', 216, 202),
    Course('MATH', 304, 509),
    Course('CSCE', 181, 500),
  ];


  Future<void> _removeSearchingClass(String check) async{
    for(int i = 0; i < searchingCourses.length; i++){
      Course removingCourse = searchingCourses.elementAt(i);
      if(removingCourse.toString() == check){
        return showCupertinoDialog<void>(
            context: context,
            builder: (BuildContext context){
              return CupertinoAlertDialog(
                title: Text('Stop searching for \n'+removingCourse.toString()+'?'),
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
                      searchingCourses.removeAt(i);
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
            largeTitle: Text('Pending Courses',)
          ),

          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                if (index >= searchingCourses.length) return null;
                return Card(
                  child: ListTile(
                    leading: CupertinoActivityIndicator(),
                    title: Text(searchingCourses.elementAt(index).toString()),
                  trailing: IconButton(icon: Icon(CupertinoIcons.clear_circled),
                                      color: CupertinoColors.systemRed,
                                      onPressed: (){_removeSearchingClass(searchingCourses.elementAt(index).toString());}
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
