import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:section_sniper/Services/auth.dart';
import 'package:section_sniper/Services/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();

  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField1 = TextEditingController();
  TextEditingController _passwordField2 = TextEditingController();

  bool prelimInputValid = true;
  bool loading = false;

  String email = '';
  String password1 = '';
  String password2 = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading(): CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        middle: Align(
          alignment: Alignment.center,
          child: Text('SelectionTime'),
        ),
      ),

      child: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain, // otherwise the logo will be tiny
                        child: FlatButton.icon(
                          icon: Icon(CupertinoIcons.padlock_solid),
                          label: Text('Sign-In'),
                          onPressed: (){
                            widget.toggleView();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain, // otherwise the logo will be tiny
                        child: FlatButton.icon(
                          color: Colors.grey[300],
                          icon: Icon(CupertinoIcons.person_add_solid),
                          label: Text('Register'),
                          onPressed: (){
                            widget.toggleView();
                          },
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.only(
                  right: 20,
                  left: 20,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    color: Colors.grey[400],
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),

                          Expanded(
                            flex: 3,
                            child: CupertinoTextField(
                              placeholder: 'Email',
                              controller: _emailField,
                              onChanged: (text){
                                setState(() {
                                  email = text;
                                });
                              },
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),

                          Expanded(
                            flex: 3,
                            child: CupertinoTextField(
                              obscureText: true,
                              placeholder: 'Password',
                              controller: _passwordField1,
                              onChanged: (text){
                                setState(() {
                                  password1 = text;
                                });
                              },
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),

                          Expanded(
                            flex: 3,
                            child: CupertinoTextField(
                              obscureText: true,
                              placeholder: 'Confirm Password',
                              controller: _passwordField2,
                              onChanged: (text){
                                setState(() {
                                  password2 = text;
                                });
                              },
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),



            Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: CupertinoButton(
                        color: Color.fromRGBO(80, 0, 0, 1),
                        child: Text('Register'),
                        onPressed: () async{
                          if(_emailField.text.isEmpty || _passwordField1.text.isEmpty || _passwordField2.text.isEmpty){
                            setState(() => prelimInputValid = false);
                            showCupertinoDialog(
                                context: context,
                                builder: (context){
                                  return CupertinoAlertDialog(
                                    title: Text('Error'),
                                    content: Text('Email/Password is empty'),
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
                          else if(_passwordField1.text.length < 8){
                            setState(() => prelimInputValid = false);
                            showCupertinoDialog(
                                context: context,
                                builder: (context){
                                  return CupertinoAlertDialog(
                                    title: Text('Error'),
                                    content: Text('Passwords need to be at least 8 characters'),
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
                          else if(_passwordField1.text != _passwordField2.text ){
                            setState(() => prelimInputValid = false);
                            showCupertinoDialog(
                                context: context,
                                builder: (context){
                                  return CupertinoAlertDialog(
                                    title: Text('Error'),
                                    content: Text('Passwords don\'t match.'),
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

                          else{
                            setState(() => prelimInputValid = true);
                          }

                          if(prelimInputValid){
                            setState(() => loading = true);
                            dynamic result = await _auth.registerWithEmailAndPassword(email, password1);
                            setState(() => loading = false);
                            if(result != null){
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context){
                                    return CupertinoAlertDialog(
                                      title: Text('Verification'),
                                      content: Text('Please check your email to verify your account'),
                                      actions: <Widget>[
                                        CupertinoButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              widget.toggleView();
                                            },
                                            child: Text('Ok'))
                                      ],
                                    );
                                  }
                              );
                            }
                            else if(result == null){
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context){
                                    return CupertinoAlertDialog(
                                      title: Text('Error'),
                                      content: Text('Please enter a valid email address'),
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
  }
}
