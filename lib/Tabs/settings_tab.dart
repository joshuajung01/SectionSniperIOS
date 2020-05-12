import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:section_sniper/Services/auth.dart';

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
    return SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: <Widget>[
            CupertinoNavigationBar(
              middle: Text('Settings'),
            ),


            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
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


            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
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


            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
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

            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CupertinoButton(
                    color: CupertinoColors.systemRed,
                    child: Text('Sign Out'),
                    onPressed: () {
                      confirmSignOut(context);
                    }
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: null,
            ),


          ],
        )
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
          child: Center(
            child: Text('Thank you for using my app. -Joshua Jung \'23'),
          ),
        );
      case 'Contact/Support':
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(category),
          ),
          child: Center(
            child: Text('Send me an email at:\n tojoshuajung@gmail.com'),
          ),
        );
      case 'Feedback':
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(category),
          ),
          child: Center(
            child: Text('Send me an email at:\n tojoshuajung@gmail.com'),
          ),
        );
    }
  }
}