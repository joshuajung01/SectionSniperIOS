import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/Joshua/IdeaProjects/SectionSniper/lib/Services/auth.dart';
import 'package:section_sniper/Models/user.dart';

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

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white,
        navigationBar: CupertinoNavigationBar(
          leading: Align(
            alignment: Alignment.centerLeft,
            child: Text('Sign-In to SectionSniper'),
          ),
          trailing: FlatButton.icon(
            icon: Icon(CupertinoIcons.person_add_solid),
            label: Text('Register'),
            onPressed: (){
              widget.toggleView();
            },
           ),
          ),

        child: SafeArea(
          top: true,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              child: Column(
                  children: <Widget>[
                    SizedBox(height: 40.0,),

                    CupertinoTextField(
                      placeholder: 'Email',
                      controller: _emailField,
                      onChanged: (text){
                        setState(() {
                          email = text;
                        });

                      },
                    ),

                    SizedBox(height: 20.0,),

                    CupertinoTextField(
                      obscureText: true,
                      placeholder: 'Password',
                      controller: _passwordField,
                      onChanged: (text){
                        setState(() {
                          password = text;
                        });
                      },
                    ),

                    SizedBox(height: 20.0,),

                    CupertinoButton(
                      color: CupertinoColors.activeBlue,
                      child: Text('Sign-In'),
                      onPressed: () async{
                        if(_emailField.text.isEmpty || _passwordField.text.isEmpty){
                          prelimInputValid = false;
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
                          prelimInputValid = false;
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
                          prelimInputValid = true;
                        }

                        if(prelimInputValid){
                          dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                          print(result.getVerified());
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
                            }
                            else if(!result.getVerified()){
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context){
                                    return CupertinoAlertDialog(
                                      title: Text('Verificaion Needed'),
                                      content: Text('Please check your email for Verification details, and restart the app'),
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
                  ],
                ),
              ),
            ),
          ),
      );
    }
  }

