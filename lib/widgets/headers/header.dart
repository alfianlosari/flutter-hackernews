import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackernews/models/item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class HeaderWidget extends StatelessWidget {
  final Item item;
  HeaderWidget(this.item);

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(item.time * 1000);
    return Container(
      padding: EdgeInsets.all(16.0),
      color: const Color(0xFFFF6600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              item.title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 17.0),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 6.0),
            child: Text(
              "${item.by} - ${timeago.format(date)} - ${item.score}",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0),
            ),
          ),
          GestureDetector(
              onTap: () {
                launchURL(item.url);
              },
              child: Container(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    item.url != null ? item.url : "-",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0),
                  )))
        ],
      ),
    );
  }
}
