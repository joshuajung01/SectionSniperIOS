import 'package:flutter/cupertino.dart';
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
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0,),

                    CupertinoTextField(
                      placeholder: 'Department',
                      controller: _deptField,
                      onChanged: (text) {
                        setState(() {
                          dept = text;
                        });
                      },
                    ),

                    SizedBox(height: 20.0,),

                    CupertinoTextField(
                      placeholder: 'Course Num',
                      controller: _courseField,
                      onChanged: (text) {
                        setState(() {
                          course = text;
                        });
                      },
                    ),

                    SizedBox(height: 20.0,),

                    CupertinoTextField(
                      placeholder: 'Section Num',
                      controller: _sectionField,
                      onChanged: (text) {
                        setState(() {
                          section = text;
                        });
                      },
                    ),
                    SizedBox(height: 40.0,),

                    CupertinoButton(
                      color: CupertinoColors.activeBlue,
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
                  ],
                ),
              ),
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
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0,),

                    CupertinoTextField(
                      placeholder: 'Department',
                      controller: _deptField,
                      onChanged: (text) {
                        setState(() {
                          dept = text;
                        });
                      },
                    ),

                    SizedBox(height: 20.0,),

                    CupertinoTextField(
                      placeholder: 'Course Num',
                      controller: _courseField,
                      onChanged: (text) {
                        setState(() {
                          course = text;
                        });
                      },
                    ),

                    SizedBox(height: 20.0,),

                    CupertinoTextField(
                      placeholder: 'Section Num',
                      controller: _sectionField,
                      onChanged: (text) {
                        setState(() {
                          section = text;
                        });
                      },
                    ),
                    SizedBox(height: 40.0,),

                    CupertinoButton(
                      color: CupertinoColors.activeBlue,
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
                          String addingCourse = dept + ' ' + course + ' ' + section;

                          dynamic result1 = await _usersDB.getPendingData();
                          await _usersDB.addPendingCourse(addingCourse);
                          dynamic result2 = await _usersDB.getPendingData();

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
                  ],
                ),
              ),
            ),
          ),
        );
    }
  }
}