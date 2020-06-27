import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:section_sniper/Services/auth.dart';
import 'package:section_sniper/Services/loading.dart';
import 'dart:ui';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  bool prelimInputValid = true;
  bool loading = false;

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white,
        navigationBar: CupertinoNavigationBar(
          middle: Align(
            alignment: Alignment.center,
            child: Text('SectionSniper'),
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
                    padding: EdgeInsets.only(
                      left: 30,
                      right: 30,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: FlatButton.icon(
                              color: Colors.grey[300],
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
                            fit: BoxFit.contain,
                            child: FlatButton.icon(
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
                      left: 20,
                      right: 20,
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
                                  child: Container()
                              ),

                              Expanded(
                                flex: 2,
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
                                  child: Container()
                              ),
                              
                              Expanded(
                                flex: 2,
                                child: CupertinoTextField(
                                  obscureText: true,
                                  placeholder: 'Password',
                                  controller: _passwordField,
                                  onChanged: (text){
                                    setState(() {
                                      password = text;
                                    });
                                  },
                                ),
                              ),

                              Expanded(
                                  flex: 1,
                                  child: Container()
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
                    children:<Widget>[
                      Expanded(
                        child: Center(
                          child: CupertinoButton(
                            color: Color.fromRGBO(80, 0, 0, 1),
                            child: Text('Sign-In'),
                            onPressed: () async{
                              if(_emailField.text.isEmpty || _passwordField.text.isEmpty){
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
                              else if(_passwordField.text.length < 8){
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
                              else{
                                setState(() => prelimInputValid = true);
                              }

                              if(prelimInputValid){
                                setState(() => loading = true);
                                dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                                if(result == null){
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context){
                                        return CupertinoAlertDialog(
                                          title: Text('Error'),
                                          content: Text('Could not sign in with those credentials'),
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
                                else if(!result.getVerified()){
                                  setState(() => loading = false);
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context){
                                        return CupertinoAlertDialog(
                                          title: Text('Verificaion Needed'),
                                          content: Text('Please check your email for Verification details'),
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
                                  setState(() => loading = true);
                                  await _auth.signOut();
                                  await _auth.signInWithEmailAndPassword(email, password);
                                  setState(() => loading = false);
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context){
                                        return CupertinoAlertDialog(
                                          title: Text('Log-In Successful'),
                                          content: Text('This app is still in Beta.\nTell Joshua if you find any bugs'),
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
                              }
                            },
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              ],
            ),
          ),
      );
    }
  }
