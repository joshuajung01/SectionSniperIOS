import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section_sniper/Models/detailedCourse.dart';
import 'package:section_sniper/Models/user.dart';
import 'package:section_sniper/Services/database.dart';


class SearchResults extends StatefulWidget {
  final List<dynamic> specificCourses;
  SearchResults({Key key, this.specificCourses}) : super(key: key);
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  Icon addIcon = Icon(CupertinoIcons.add_circled);
  @override
  Widget build(BuildContext context) {
      final users = Provider.of<User>(context);
      DatabaseService _usersDB = DatabaseService(uid: users.uid);
      List<dynamic> allCourses = widget.specificCourses;

      return SafeArea(
        top: true,
        child: CustomScrollView(
          slivers: <Widget>[
            
            CupertinoSliverNavigationBar(
              heroTag: 'navBar1',
              largeTitle: Text(allCourses.elementAt(0).toString().substring(0, 9)),
            ),

            SliverFixedExtentList(
              itemExtent: 70.0,
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  if (index >= allCourses.length) return null;
                  else{
                    DetailedCourse course = allCourses.elementAt(index);
                    if(!course.selected){
                      addIcon = Icon(CupertinoIcons.add_circled);
                    }
                    else{
                      addIcon = Icon(CupertinoIcons.check_mark_circled_solid);
                    }

                    if(allCourses.elementAt(index).open > 0){
                      return Card(
                        child: ListTile(
                          leading: Icon(CupertinoIcons.check_mark_circled_solid,
                            color: CupertinoColors.activeGreen,),
                          title: Text(allCourses.elementAt(index).toString()),
                          trailing: IconButton(icon: addIcon,
                            onPressed: (){
                              setState(() {
                                if(course.selected){
                                  addIcon = Icon(CupertinoIcons.add_circled);
                                  _usersDB.removePendingCourse(course.toString());
                                  course.reverseSelected();
                                }
                                else{
                                  addIcon = Icon(CupertinoIcons.check_mark_circled_solid);
                                  _usersDB.addPendingCourse(course.toString());
                                  course.reverseSelected();
                                }

                              });
                            },
                          ),

                          onTap: () {
                            showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: Text(course.toString()),
                                    content: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text('Title: '+course.title),
                                          Text('Professor: '+course.profName),
                                          Text('Seats Availible: '+course.open.toString()),
                                          Text('Total Seats: '+course.maxCap.toString()),
                                          Text('CRN: '+course.crn),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  );
                                }
                            );
                          }
                        ),
                      );
                    }

                    else {
                      return Card(
                        child: ListTile(
                          leading: Icon(CupertinoIcons.clear_circled_solid,
                            color: CupertinoColors.systemRed,),
                          title: Text(allCourses.elementAt(index).toString()),
                          trailing: IconButton(icon: addIcon,
                            onPressed: (){
                              setState(() {
                                if(course.selected){
                                  addIcon = Icon(CupertinoIcons.add_circled);
                                  _usersDB.removePendingCourse(course.toString());
                                  course.reverseSelected();
                                }
                                else{
                                  addIcon = Icon(CupertinoIcons.check_mark_circled_solid);
                                  _usersDB.addPendingCourse(course.toString());
                                  course.reverseSelected();
                                }

                                });
                              },
                            ),
                            onTap: () {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: Text(course.toString()),
                                      content: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            Text('Title: '+course.title),
                                            Text('Professor: '+course.profName),
                                            Text('Seats Availible: '+course.open.toString()),
                                            Text('Total Seats: '+course.maxCap.toString()),
                                            Text('CRN: '+course.crn),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          child: Text('Ok'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    );
                                  }
                              );
                            }

                          ),
                        );
                      }


                  }
                },
              ),
            ),
            
          ],
        ),
      );
    }
  }

