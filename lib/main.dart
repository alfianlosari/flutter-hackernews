import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackernews/models/stories.dart';
import 'package:hackernews/widgets/pages/feed_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      color: const Color(0xFFFF6600),
      title: 'Hacker News',
      home: MainTab(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainTab extends StatelessWidget {
  MainTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: const Color(0xFFFF6600),
        items: [
          BottomNavigationBarItem(title: Text("Top"), icon: Icon(Icons.grade)),
          BottomNavigationBarItem(
              title: Text("Newest"), icon: Icon(Icons.new_releases)),
          BottomNavigationBarItem(
              title: Text("Jobs"), icon: Icon(Icons.people)),
          BottomNavigationBarItem(
              title: Text("Shows"), icon: Icon(Icons.slideshow)),
          BottomNavigationBarItem(
              title: Text("Asks"), icon: Icon(Icons.question_answer))
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return FeedPage(story: Stories.top);
          case 1:
            return FeedPage(story: Stories.newest);
          case 2:
            return FeedPage(story: Stories.jobs);
          case 3:
            return FeedPage(story: Stories.shows);
          case 4:
            return FeedPage(story: Stories.asks);
          default:
            break;
        }
      },
    );
  }
}
