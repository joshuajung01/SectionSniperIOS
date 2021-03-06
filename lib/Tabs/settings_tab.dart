import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:section_sniper/Services/auth.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsTab extends StatelessWidget {

  final AuthService _auth = AuthService();

  void confirmSignOut(BuildContext context) async {
    return showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Are you sure you want to sign-out?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              CupertinoDialogAction(
                child: Text('Yes'),
                onPressed: () async{
                  Navigator.of(context).pop();
                  _auth.signOut();
                },
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: SafeArea(
          top: true,
          bottom: true,
          child: Container(
            color: Colors.grey[300],
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(),
                ),

                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Card(
                      child: ListTile(
                        leading: Icon(CupertinoIcons.info),
                        title: Text('About'),
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      DetailPage(category: 'About')));
                        },
                        trailing: Icon(CupertinoIcons.down_arrow),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Container(),
                ),

                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Card(
                      child: ListTile(
                        leading: Icon(CupertinoIcons.group_solid),
                        title: Text('Contact/Support'),
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      DetailPage(category: 'Contact/Support')));
                        },
                        trailing: Icon(CupertinoIcons.down_arrow),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Container(),
                ),

                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Card(
                      child: ListTile(
                        leading: Icon(CupertinoIcons.conversation_bubble),
                        title: Text('Feedback'),
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      DetailPage(category: 'Feedback')));
                        },
                        trailing: Icon(CupertinoIcons.down_arrow),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Container(),
                ),

                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CupertinoButton(
                        color: Color.fromRGBO(80, 0, 0, 1),
                        child: Text('Sign Out'),
                        onPressed: () {
                          confirmSignOut(context);
                        }
                    ),
                  ),
                ),

                Expanded(
                  flex: 4,
                  child: Container(),
                ),


              ],
            ),
          )
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String category;
  DetailPage({Key key, this.category}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    switch (category){
      case 'About':
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(category),
          ),
          child: SafeArea(
            top: true,
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('This app will send you a notification when a seat becomes available in a class for the upcoming semester FALL 2020.'),
                          ),
                          Expanded(
                            flex: 2,
                            child:  Text('It is up to you to go sign up for that course when the spot opens up.'),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('This is my first time making an app, so it\'s definitely a work in progress.'),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('I hope that the app makes your life a bit easier by helping you get the classes you want with the professors you want.'),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: <Widget>[
                                Text('Thanks and gig\'em,\n'),
                                Text('Joshua Jung \'23'),
                                Text('Mark 10:27'),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      case 'Contact/Support':
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(category),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(),
              ),

              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: <Widget>[
                      Text('Questions or Need Help?'),
                      Text('tamu.selection.time@gmail.com'),
                    ],
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: <Widget>[
                      Text('For faster responses, message me on LinkedIn'),
                      RichText(
                        text: TextSpan(
                          text: 'www.linkedin.com/in/joshuajung01/',
                          style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue,fontSize: 16),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch('https://www.linkedin.com/in/joshuajung01/');
                            },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                flex: 2,
                child: Container(),
              ),
            ],
          ),
        );
      case 'Feedback':
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(category),
          ),
          child: SafeArea(
            top: true,
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),

                  Text('If you want to want to give some quick feedback, please fill out the form it only takes one minute: '),
                  RichText(
                    text: TextSpan(
                      text: 'https://forms.gle/6Rumyo2WgMA3yJWV8',
                      style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue,fontSize: 16),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          launch('https://forms.gle/6Rumyo2WgMA3yJWV8');
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
        );
    }
  }
}