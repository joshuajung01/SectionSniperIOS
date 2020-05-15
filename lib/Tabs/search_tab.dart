import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:section_sniper/Models/detailedCourse.dart';
import 'package:http/http.dart' as http;

class SearchTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchTabState();
  }
}

class _SearchTabState extends State<SearchTab>{
//  List<Course> recentSearchCourses = [
//    Course('MATH', 308, 511),
//    Course('STAT', 211, 504),
//    Course('CSCE', 121, 501),
//    Course('PHYS', 216, 202),
//    Course('MATH', 304, 509),
//    Course('CSCE', 181, 500),
//  ];
//
//  List<Course> availibleCourses = [
//    Course('MATH', 308, 511),
//    Course('STAT', 211, 504),
//    Course('CSCE', 121, 501),
//    Course('PHYS', 216, 202),
//    Course('MATH', 304, 509),
//    Course('CSCE', 181, 500),
//  ];

  String dept;
  String num;

  String term;

  TextEditingController _deptField = TextEditingController();
  TextEditingController _numField = TextEditingController();

//  Future<List> request_terms() async{
//    final response = await http.get('https://compassxe-ssb.tamu.edu/StudentRegistrationSsb/ssb/classSearch/getTerms?dataType=json&offset=1&max=500');
//    return json.decode(response.body);
//  }

  Future requestSections(String depts, String nums) async{
    Map<String, String> headers = {};
    String url = 'https://compassxe-ssb.tamu.edu/StudentRegistrationSsb/ssb/term/search?mode=courseSearch';
    var data = {'dataType': 'json', 'term': '202031'};

    http.Response response = await http.post(url, body: data);
    String rawCookie = response.headers['set-cookie'];

    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }

    String url2 = 'https://compassxe-ssb.tamu.edu/StudentRegistrationSsb/ssb/searchResults/searchResults?txt_subjectcoursecombo='+ depts + nums +'&txt_term=202031&pageOffset=0&pageMaxSize=500&sortColumn=subjectDescription&sortDirection=asc';
    http.Response response2 = await http.get(url2, headers: headers);
    return json.decode(response2.body);
  }

  List findAllClasses(data, depts, nums) {
    List arr = data["data"];
    return arr;
  }


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
                        child: CupertinoTextField(
                          placeholder: 'Ex: MATH',
                          controller: _deptField,
                          onChanged: (text){dept = text.toUpperCase();},
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
                        child: CupertinoTextField(
                          placeholder: 'Ex: 151',
                          controller: _numField,
                          onChanged: (text){num = text;},
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
                    onPressed: (){
                      if(_deptField.text.isNotEmpty && _numField.text.isNotEmpty){
                        List availibleClasses = [];
                        requestSections(dept, num).then((value){
                          List arr = findAllClasses(value, dept, num);
                          for(int i = 0; i < arr.length; i++){

                            Map<dynamic, dynamic> c = arr[i];
                            String d = c['subject'];
                            String n = c['courseNumber'];
                            String s = c['sequenceNumber'];
                            int o = c['seatsAvailable'];
                            String cr = c['courseReferenceNumber'];

                            DetailedCourse smile = DetailedCourse(d, n, s, o, cr,);
                            availibleClasses.add(smile);
                          }
                          print(availibleClasses);
                        });
                      }



                    },
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

//class Session {
////  Map<String, String> headers = {'code'};
//
//  Future<List<dynamic>> get(String url) async {
//    http.Response response = await http.get(url);
////    updateCookie(response);
//    return json.decode(response.body);
//  }
//
//  Future<Map> post(String url, dynamic data) async {
//    http.Response response = await http.post(url, body: data);
////    updateCookie(response);
//    return json.decode(response.body);
//  }
//
////  void updateCookie(http.Response response) {
////    String rawCookie = response.headers['set-cookie'];
////    if (rawCookie != null) {
////      int index = rawCookie.indexOf(';');
////      headers['cookie'] =
////      (index == -1) ? rawCookie : rawCookie.substring(0, index);
////    }
////  }
//}