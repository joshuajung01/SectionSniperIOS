import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section_sniper/Models/detailedCourse.dart';
import 'package:http/http.dart' as http;
import 'package:section_sniper/Models/user.dart';
import 'package:section_sniper/Services/database.dart';
import 'package:section_sniper/Services/loading.dart';
import 'package:section_sniper/Tabs/searchResults.dart';

class SearchTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchTabState();
  }
}

class _SearchTabState extends State<SearchTab>{
  bool loading = false;

  String dept;
  String num;

  String term;

  TextEditingController _deptField = TextEditingController();
  TextEditingController _numField = TextEditingController();


  List<dynamic> orgPendingData = [];

  Future requestSections(String depts, String nums) async{
    Map<String, String> headers = {};
    String url = 'https://compassxe-ssb.tamu.edu/StudentRegistrationSsb/ssb/term/search?mode=courseSearch';
    var data = {'dataType': 'json', 'term': '202111'};

    http.Response response = await http.post(url, body: data);
    String rawCookie = response.headers['set-cookie'];


    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }


    //smile
    String url2 = 'https://compassxe-ssb.tamu.edu/StudentRegistrationSsb/ssb/searchResults/searchResults?txt_subjectcoursecombo='+ depts + nums +'&txt_term=202111&pageOffset=0&pageMaxSize=500&sortColumn=subjectDescription&sortDirection=asc';
    http.Response response2 = await http.get(url2, headers: headers);
    return json.decode(response2.body);
  }



  List findAllClasses(data, depts, nums) {
    List arr = data["data"];
    return arr;
  }

  Future<List> getCurrentPendingData() async {
    List pendingData = [];
    final users = Provider.of<User>(context);
    DatabaseService _usersDB = DatabaseService(uid: users.uid);
    pendingData = await _usersDB.getPendingData();
    return pendingData;
  }

  @override
  Widget build(BuildContext context) {
    getCurrentPendingData().then((value) => orgPendingData = value);
    return loading ? Loading() : CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Search'),
      ),
      child: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: <Widget>[

            Expanded(
              flex: 1,
              child: Container(),
            ),

            Expanded(
              flex: 8,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    color: Colors.grey[400],
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Container(
                        color: Colors.grey[300],
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),

                            Expanded(
                              flex: 3,
                              child: Row(
                                children: <Widget>[
                                  Container(padding: EdgeInsets.all(8.0)),
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 100),
                                     child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Dept:'),
                                    ),
                                  ),
                                  Container(padding: EdgeInsets.all(8.0)),
                                  Expanded(
                                      child: Form(
                                        child: CupertinoTextField(
                                          placeholder: 'Ex: MATH',
                                          controller: _deptField,
                                          onChanged: (text){dept = text.substring(0,4).toUpperCase();},
                                        ),
                                      )
                                  ),
                                  Container(padding: EdgeInsets.all(8.0)),
                                ],
                              ),
                            ),


                            Expanded(
                              flex: 3,
                              child: Row(
                                children: <Widget>[
                                  Container(padding: EdgeInsets.all(8.0)),
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 100),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Course: '),
                                    ),
                                  ),
                                  Container(padding: EdgeInsets.all(8.0)),
                                  Expanded(
                                      child: Form(
                                        child: CupertinoTextField(
                                          placeholder: 'Ex: 151',
                                          controller: _numField,
                                          onChanged: (text){num = text.substring(0,3);},
                                        ),
                                      )
                                  ),
                                  Container(padding: EdgeInsets.all(8.0)),
                                ],
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Container(),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),


            Expanded(
              flex: 3,
              child: Row(
                children: <Widget>[
                  Expanded(child:
                  Center(
                    child: CupertinoButton(
                      color: Color.fromRGBO(80, 0, 0, 1),
                      child: Text('Search'),
                      onPressed: (){
                        setState(() {loading = true;});
                        List availibleClasses = [];
                        if(_deptField.text.isNotEmpty && _numField.text.isNotEmpty){
                          requestSections(dept, num).then((value) {
                            if (value['totalCount'] != 0) {
                              List arr = findAllClasses(value, dept, num);
                              for (int i = 0; i < arr.length; i++) {
                                bool selected = false;
                                Map<dynamic, dynamic> c = arr[i];
                                String d = c['subject'];
                                String n = c['courseNumber'];
                                String s = c['sequenceNumber'];
                                int o = c['seatsAvailable'];
                                String cr = c['courseReferenceNumber'];
                                String t = c['courseTitle'];
                                String pn = '';
                                if (c['faculty'].length != 0) {
                                  pn = c['faculty'][0]['displayName'];
                                }
                                int mc = c['maximumEnrollment'];

                                String className = d + " " + n + " " + s;
                                if(orgPendingData.contains(className)){
                                  selected = true;
                                }
                                DetailedCourse smile = DetailedCourse(d, n, s, o, cr, t, pn, mc, selected);
                                availibleClasses.add(smile);
                              }
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          SearchResults(specificCourses: availibleClasses,)
                                  )
                                );
                                setState(() {loading = false;});
                              }



                            else{
                              showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: Text('Error'),
                                      content: Text('Course not Found'),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          child: Text('Ok'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            setState(() {loading = false;});
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                );
                              setState(() {loading = false;});
                              }

                            }
                          );
                        }
                        else{
                          showCupertinoDialog<void>(
                              context: context,
                              builder: (BuildContext context){
                                return CupertinoAlertDialog(
                                  title: Text('Uh-oh'),
                                  content: Text('Please make sure to fill out all information'),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {loading = false;});
                                      },
                                    ),
                                  ],
                                );
                              }
                          );
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
      ),
    );
  }
}
