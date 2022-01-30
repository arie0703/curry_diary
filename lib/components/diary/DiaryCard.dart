import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';

class DiaryCard extends StatefulWidget {
  const DiaryCard(
      {Key? key, required this.title, required this.content, this.imageURL})
      : super(key: key);
  final String title;
  final String content;
  final String? imageURL;
  @override
  _DiaryCardState createState() => _DiaryCardState();
}

class _DiaryCardState extends State<DiaryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: CommonColor.primaryColor[50],
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text(widget.title),
            subtitle: Text(widget.content),
          ),
          if (widget.imageURL != null)
            Container(
                alignment: Alignment.center,
                child: Image.network(widget.imageURL!)),
          ButtonTheme(
            child: ButtonBar(
              children: <Widget>[
                ElevatedButton(
                  child: const Text('レシピを見る'),
                  onPressed: () {
                    debugPrint("button pressed");
                  },
                ),
                ElevatedButton(
                  child: const Text('いいね'),
                  onPressed: () {
                    debugPrint("button pressed");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
