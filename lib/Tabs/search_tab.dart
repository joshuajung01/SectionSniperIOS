import 'package:flutter/cupertino.dart';
import '../Models/course.dart';


class SearchTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchTabState();
  }
}

class _SearchTabState extends State<SearchTab>{
  List<Course> recentSearchCourses = [
    Course('MATH', 308, 511),
    Course('STAT', 211, 504),
    Course('CSCE', 121, 501),
    Course('PHYS', 216, 202),
    Course('MATH', 304, 509),
    Course('CSCE', 181, 500),
  ];

  List<Course> availibleCourses = [
    Course('MATH', 308, 511),
    Course('STAT', 211, 504),
    Course('CSCE', 121, 501),
    Course('PHYS', 216, 202),
    Course('MATH', 304, 509),
    Course('CSCE', 181, 500),
  ];

  final _formDeptKey = GlobalKey<FormState>();
  final _formNumKey = GlobalKey<FormState>();

  String dept;
  int num;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Column(
        children: <Widget>[
          CupertinoNavigationBar(
            middle: Text('Search'),
          ),

          Container(padding: EdgeInsets.all(20.0)),

          Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Container(padding: EdgeInsets.all(8.0)),
                  Container(
                    constraints: BoxConstraints(maxWidth: 100),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Department:'),
                    ),
                  ),
                  Container(padding: EdgeInsets.all(8.0)),
                  Expanded(
                      child: Form(
                        key: _formDeptKey,
                        child: CupertinoTextField(
                          placeholder: 'Ex: MATH',
                          onSubmitted: (text){dept = text.toUpperCase();},
                        ),
                      )
                  ),
                  Container(padding: EdgeInsets.all(8.0)),
                ],
              ),
          ),


          Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Container(padding: EdgeInsets.all(8.0)),
                  Container(
                    constraints: BoxConstraints(maxWidth: 100),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Course Num: '),
                    ),
                  ),
                  Container(padding: EdgeInsets.all(8.0)),
                  Expanded(
                      child: Form(
                        key: _formNumKey,
                        child: CupertinoTextField(
                          placeholder: 'Ex: 151',
                          onSubmitted: (text){num = int.parse(text);},
                        ),
                      )
                  ),
                  Container(padding: EdgeInsets.all(8.0)),
                ],
              ),
          ),

          Expanded(
            flex: 8,
            child: Row(
              children: <Widget>[
                Expanded(child:
                Center(
                  child: CupertinoButton.filled(
                    child: Text('Search'),
                    onPressed: (){},
                  ),
                )
                )
              ],
            ),
          )
        ],
      )
    );
  }
}

//class SearchResults extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    return _SearchResultsState();
//  }
//}
//
//class _SearchResultsState extends State<SearchResults>{
//  //TODO: Need a function to get data from firebase storage
//  @override
//  Widget build(BuildContext context) {
//    return SafeArea(
//    );
//  }
//}