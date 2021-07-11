import 'package:apple_music_list_app/play_widget.dart';
import 'package:apple_music_list_app/widget_memo/browse_widget.dart';
import 'package:apple_music_list_app/widget/search_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: '',
      home: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          // ignore: prefer_const_literals_to_create_immutables
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text('Home'),
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Search'),
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow), title: Text('聞く'),
            ),
          ],
        ),
        // ignore: missing_return
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                builder: (context) => BrowseWidget(),
              );
            case 1:
              return CupertinoTabView(
                builder: (context) => SearchWidget(),
              );
            case 2:
              return CupertinoTabView(
                builder: (context) => PlayWidget(),
              );
            default:
              break;
          }
        },
      ),
    );
  }
}