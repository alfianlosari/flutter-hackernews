import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:hackernews/models/item.dart';

class CommentRow extends StatelessWidget {
  final Item item;
  CommentRow({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = List<Widget>();
    children.add(CommentItem(
      key: Key("${item.id}"),
      item: item,
    ));
    if (item.comments.length > 0) {
      List<Widget> comments = item.comments
          .map((item) => CommentRow(
                item: item,
                key: Key("${item.id}"),
              ))
          .toList();

      children.add(Padding(
        padding: EdgeInsets.only(left: 1.0),
        child: IntrinsicHeight(
            child: Row(
          children: <Widget>[
            Container(
              width: 15.0,
              color: const Color(0xFFFF6600),
            ),
            Expanded(child: Column(children: comments))
          ],
        )),
      ));
    }
    return Column(children: children);
  }
}

class CommentItem extends StatelessWidget {
  final Item item;
  CommentItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(item.time * 1000);
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 6.0),
                  child: Text(
                    item.by != null ? item.by : 'unknown',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 17.0),
                  ),
                ),
                Container(
                    child: Text(
                  timeago.format(date),
                  style: TextStyle(
                      color: const Color(0xFFFF6600),
                      fontWeight: FontWeight.w700,
                      fontSize: 17.0),
                )),
              ],
            )),
            Container(
              padding: EdgeInsets.only(top: 6.0),
              child: Text(
                item.text.isNotEmpty ? item.text : "(Not available)",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
