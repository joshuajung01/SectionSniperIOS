import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:section_sniper/Models/detailedCourse.dart';
import 'package:http/http.dart' as http;
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


    //smile
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

    return loading ? Loading() : SafeArea(
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
                      setState(() {loading = true;});
                      List availibleClasses = [];
                      if(_deptField.text.isNotEmpty && _numField.text.isNotEmpty){
                        requestSections(dept, num).then((value) {
                          if (value['totalCount'] != 0) {
                            List arr = findAllClasses(value, dept, num);
                            for (int i = 0; i < arr.length; i++) {
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

                              DetailedCourse smile = DetailedCourse(d, n, s, o, cr, t, pn, mc);
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
    );
  }
}
