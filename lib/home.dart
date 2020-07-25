import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:section_sniper/Services/notification.dart';
import 'Models/course.dart';
import 'Tabs/home_tab.dart';
import 'Tabs/search_tab.dart';
import 'Tabs/wishlist_tab.dart';
import 'Tabs/settings_tab.dart';
import 'package:section_sniper/Services/database.dart';
import 'package:provider/provider.dart';

class SectionSniper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  StreamProvider<QuerySnapshot>.value(
        value: DatabaseService().course,
        child: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget{
  List<Course> convertStringToCourse(arr){

    List<Course> openCourses = [];

    for(String frag in arr){
      List splitCourse = frag.split(" ");
      String d = splitCourse[0];
      int n = int.parse(splitCourse[1]);
      int s = int.parse(splitCourse[2]);
      Course addingCourse = Course(d, n, s);
      openCourses.add(addingCourse);
    }

    return openCourses;
  }

  @override
  Widget build(BuildContext context){
    PushNotificationsManager().init();

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.news_solid),
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings_solid),
          ),
        ],
      ),
      tabBuilder: (context, i) {
        // ignore: missing_return
        switch (i) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HomeTab(),
              );
            });
          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: SearchTab(),
              );
            });
          case 2:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: WishlistTab(),
              );
            });
          case 3:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: SettingsTab(),
              );
            });
        }
        return null;
      }
    );
  }
}
