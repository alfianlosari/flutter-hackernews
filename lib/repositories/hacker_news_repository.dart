import 'package:firebase/firebase_io.dart';
import 'package:hackernews/models/item.dart';
import 'package:hackernews/models/stories.dart';
import 'dart:async';

class HackerNewsRepository {
  FirebaseClient _client = FirebaseClient.anonymous();
  String _rootAPIPath = "https://hacker-news.firebaseio.com/v0/";

  static final HackerNewsRepository _singleton =
      HackerNewsRepository._internal();
  HackerNewsRepository._internal();

  factory HackerNewsRepository() {
    return _singleton;
  }

  Future<List<Item>> getComments(Item item) async {
    if (item.kids.length == 0) {
      return List();
    } else {
      var comments = await Future.wait(item.kids.map((id) => getItem(id)));
      var nestedComments =
          await Future.wait(comments.map((comment) => getComments(comment)));
      for (var i = 0; i < nestedComments.length; i++) {
        comments[i].comments = nestedComments[i];
      }
      return comments;
    }
  }

  Future<Item> getItem(int id) async {
    var itemPath = "$_rootAPIPath/item/$id.json";
    var response = await _client.get(itemPath);
    return Item.fromJson(response);
  }

  Future<List<dynamic>> getFeed(Stories story) async {
    var path = '';
    switch (story) {
      case Stories.top:
        path = 'topstories';
        break;

      case Stories.newest:
        path = 'newstories';
        break;

      case Stories.jobs:
        path = 'jobstories';
        break;

      case Stories.shows:
        path = 'showstories';
        break;

      case Stories.asks:
        path = "askstories";
    }
    var fullPath = "$_rootAPIPath$path.json";
    var response = await _client.get(fullPath);
    return response;
  }
}
