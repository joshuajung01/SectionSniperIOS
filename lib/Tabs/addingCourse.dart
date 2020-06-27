import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section_sniper/Services/database.dart';
import 'package:section_sniper/Models/user.dart';
import 'package:section_sniper/Services/loading.dart';


class AddingCourse extends StatefulWidget {
  final String category;
  AddingCourse({Key key, this.category}) : super(key: key);

  @override
  _AddingCourseState createState() => _AddingCourseState();
}

class _AddingCourseState extends State<AddingCourse> {

  TextEditingController _deptField = TextEditingController();
  TextEditingController _courseField = TextEditingController();
  TextEditingController _sectionField = TextEditingController();

  bool prelimInputValid = true;
  bool loading = false;

  String dept = '';
  String course = '';
  String section = '';

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<User>(context);
    DatabaseService _usersDB = DatabaseService(uid: users.uid);

    switch (widget.category) {
      case 'Current':
        return loading ? Loading() : CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('Add an Enrolled Course'),
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
                                              onChanged: (text) {
                                                setState(() {
                                                  dept = text;
                                                });
                                              },
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
                                          child: Text('Course Num:'),
                                        ),
                                      ),
                                      Container(padding: EdgeInsets.all(8.0)),
                                      Expanded(
                                          child: Form(
                                            child: CupertinoTextField(
                                              placeholder: 'Ex: 151',
                                              controller: _courseField,
                                              onChanged: (text) {
                                                setState(() {
                                                  course = text;
                                                });
                                              },
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
                                          child: Text('Section Num:'),
                                        ),
                                      ),
                                      Container(padding: EdgeInsets.all(8.0)),
                                      Expanded(
                                          child: Form(
                                            child: CupertinoTextField(
                                              placeholder: 'Ex: 500',
                                              controller: _sectionField,
                                              onChanged: (text) {
                                                setState(() {
                                                  section = text;
                                                });
                                              },
                                            ),
                                          )
                                      ),
                                      Container(padding: EdgeInsets.all(8.0)),
                                    ],
                                  ),
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
                      Expanded(
                        child: Center(
                          child: CupertinoButton(
                            color: Color.fromRGBO(80, 0, 0, 1),
                            child: Text('Add'),
                            onPressed: () async {
                              if (_deptField.text.isEmpty || _courseField.text.isEmpty ||
                                  _sectionField.text.isEmpty) {
                                setState(() {
                                  prelimInputValid = false;
                                });
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: Text('Uh-oh'),
                                        content: Text('Some fields were left empty!'),
                                        actions: <Widget>[
                                          CupertinoButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('ok'))
                                        ],
                                      );
                                    }
                                );
                              }

                              else if (_deptField.text.length > 4 ||
                                  _courseField.text.length > 3 ||
                                  _sectionField.text.length > 3) {
                                setState(() {
                                  prelimInputValid = false;
                                });
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: Text('Uh-oh'),
                                        content: Text(
                                            'Please check the input data again'),
                                        actions: <Widget>[
                                          CupertinoButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Ok'))
                                        ],
                                      );
                                    }
                                );
                              }

                              else {
                                setState(() {
                                  prelimInputValid = true;
                                });
                              }

                              if (prelimInputValid) {
                                setState(() {
                                  loading = true;
                                });
                                String addingCourse = dept.toUpperCase() + ' ' + course + ' ' + section;

                                dynamic result1 = await _usersDB.getCurrentData();
                                await _usersDB.addCurrentCourse(addingCourse);
                                dynamic result2 = await _usersDB.getCurrentData();

                                if (result1.length == result2.length) {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text('Error'),
                                          content: Text('Failed to add the course'),
                                          actions: <Widget>[
                                            CupertinoButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Ok'))
                                          ],
                                        );
                                      }
                                  );
                                  setState(() => loading = false);
                                }

                                else {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text('Success'),
                                          content: Text('Added '+addingCourse+' to Current Courses'),
                                          actions: <Widget>[
                                            CupertinoButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Ok'))
                                          ],
                                        );
                                      }
                                  );
                                  setState(() => loading = false);
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        );


      case 'Pending':
        return loading ? Loading() : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
            middle: Text('Add a Wishlist Course'),
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
                                              onChanged: (text) {
                                                setState(() {
                                                  dept = text;
                                                });
                                              },
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
                                          child: Text('Course Num:'),
                                        ),
                                      ),
                                      Container(padding: EdgeInsets.all(8.0)),
                                      Expanded(
                                          child: Form(
                                            child: CupertinoTextField(
                                              placeholder: 'Ex: 151',
                                              controller: _courseField,
                                              onChanged: (text) {
                                                setState(() {
                                                  course = text;
                                                });
                                              },
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
                                          child: Text('Section Num:'),
                                        ),
                                      ),
                                      Container(padding: EdgeInsets.all(8.0)),
                                      Expanded(
                                          child: Form(
                                            child: CupertinoTextField(
                                              placeholder: 'Ex: 500',
                                              controller: _sectionField,
                                              onChanged: (text) {
                                                setState(() {
                                                  section = text;
                                                });
                                              },
                                            ),
                                          )
                                      ),
                                      Container(padding: EdgeInsets.all(8.0)),
                                    ],
                                  ),
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
                      Expanded(
                        child: Center(
                          child:CupertinoButton(
                            color: Color.fromRGBO(80, 0, 0, 1),
                            child: Text('Add'),
                            onPressed: () async {
                              if (_deptField.text.isEmpty ||
                                  _courseField.text.isEmpty ||
                                  _sectionField.text.isEmpty) {
                                setState(() {
                                  prelimInputValid = false;
                                });
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: Text('Uh-oh'),
                                        content: Text(
                                            'Some fields were left empty!'),
                                        actions: <Widget>[
                                          CupertinoButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('ok'))
                                        ],
                                      );
                                    }
                                );
                              }

                              else if (_deptField.text.length > 4 ||
                                  _courseField.text.length > 3 ||
                                  _sectionField.text.length > 3) {
                                setState(() {
                                  prelimInputValid = false;
                                });
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: Text('Uh-oh'),
                                        content: Text(
                                            'Please check the input data again'),
                                        actions: <Widget>[
                                          CupertinoButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Ok'))
                                        ],
                                      );
                                    }
                                );
                              }

                              else {
                                setState(() {
                                  prelimInputValid = true;
                                });
                              }


                              if (prelimInputValid) {
                                setState(() {
                                  loading = true;
                                });
                                String addingCourse = dept.toUpperCase() + ' ' +
                                    course + ' ' + section;


                                dynamic result1 = await _usersDB
                                    .getPendingData();
                                await _usersDB.addPendingCourse(addingCourse);
                                dynamic result2 = await _usersDB
                                    .getPendingData();

                                if (result1.length == result2.length) {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text('Error'),
                                          content: Text(
                                              'Failed to add the course'),
                                          actions: <Widget>[
                                            CupertinoButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Ok'))
                                          ],
                                        );
                                      }
                                  );
                                  setState(() => loading = false);
                                }

                                else {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text('Success'),
                                          content: Text(
                                              'Added ' + addingCourse +
                                                  ' to Wishlist Courses'),
                                          actions: <Widget>[
                                            CupertinoButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Ok'))
                                          ],
                                        );
                                      }
                                  );
                                  setState(() => loading = false);
                                }
                              }
                            }
                          )
                        ),
                      ),


                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}