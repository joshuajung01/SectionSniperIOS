import 'package:flutter/cupertino.dart';
import 'Tabs/home_tab.dart';
import 'Tabs/search_tab.dart';
import 'Tabs/wishlist_tab.dart';
import 'Tabs/settings_tab.dart';

class SectionSniper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  HomeScreen();
  }
}

class HomeScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              title: Text('Home')
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              title: Text('Search')
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.news),
              title: Text('Wishlist')
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              title: Text('Settings')
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
