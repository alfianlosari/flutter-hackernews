import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackernews/models/item.dart';
import 'package:hackernews/repositories/hacker_news_repository.dart';
import 'package:hackernews/widgets/rows/comment_row.dart';
import 'package:hackernews/widgets/headers/header.dart';

class CommentPage extends StatefulWidget {
  CommentPage({Key key, this.item}) : super(key: key);
  final Item item;

  @override
  State<StatefulWidget> createState() {
    return _CommentPageState();
  }
}

class _CommentPageState extends State<CommentPage> {
  HackerNewsRepository repository = HackerNewsRepository();
  Map<int, Item> comments = Map();

  Future<Item> getItemWithComments(int id) async {
    var item = await repository.getItem(id);
    item.comments = await repository.getComments(item);
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
          actionsForegroundColor: const Color(0xFFFF6600),
          middle: Text("Comments (${widget.item.descendants})")),
      child: (widget.item.kids.length == 0)
          ? ListView(
              children: <Widget>[
                HeaderWidget(widget.item),
                Container(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Text("There are no comments available",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17.0)),
                  ),
                )
              ],
            )
          : ListView.builder(
              itemCount: 1 + widget.item.kids.length,
              itemBuilder: (BuildContext context, int position) {
                if (position == 0) {
                  return HeaderWidget(widget.item);
                }

                return FutureBuilder(
                    future: getItemWithComments(widget.item.kids[position - 1]),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (comments[position - 1] != null) {
                        var item = comments[position - 1];
                        return CommentRow(
                          item: item,
                          key: Key(item.id.toString()),
                        );
                      }
                      if (snapshot.hasData && snapshot.data != null) {
                        var item = snapshot.data;
                        comments[position - 1] = item;
                        return CommentRow(
                            item: item, key: Key(item.id.toString()));
                      } else if (snapshot.hasError) {
                        return Container(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: Text("Error Loading Item")),
                        );
                      } else {
                        return Container(
                          padding: EdgeInsets.all(32.0),
                          child: Center(
                            child: CupertinoActivityIndicator(
                              animating: true,
                            ),
                          ),
                        );
                      }
                    });
              },
            ),
    );
  }
}
