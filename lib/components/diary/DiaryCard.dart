import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryCard extends StatefulWidget {
  const DiaryCard(
      {Key? key,
      required this.title,
      required this.content,
      this.imageURL,
      required this.userID})
      : super(key: key);
  final String title;
  final String content;
  final String? imageURL;
  final String userID;
  @override
  _DiaryCardState createState() => _DiaryCardState();
}

class _DiaryCardState extends State<DiaryCard> {
  @override
  Widget build(BuildContext context) {
    // 親widgetから渡されたユーザーIDを元に、投稿ユーザーの情報を取得
    // 投稿ユーザー情報取得後にWidgetを描画する
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userID)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(),
            );
          }
          if (snapshot.hasError) {
            //
            return const Text('Something went wrong');
          }
          return Card(
            color: CommonColor.primaryColor[50],
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(widget.title),
                  subtitle: Text(snapshot.data['name']),
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
        });
  }
}
