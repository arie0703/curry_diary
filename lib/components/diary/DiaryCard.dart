import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';
import 'package:curry_app/components/diary/EditDiary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiaryCard extends StatefulWidget {
  const DiaryCard({
    Key? key,
    required this.data,
    required this.docID,
  }) : super(key: key);
  final Map data;
  final String docID;
  @override
  _DiaryCardState createState() => _DiaryCardState();
}

class _DiaryCardState extends State<DiaryCard> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // 親widgetから渡されたユーザーIDを元に、投稿ユーザーの情報を取得
    // 投稿ユーザー情報取得後にWidgetを描画する

    void updateLikeCount() async {
      int count = 0;

      await FirebaseFirestore.instance
          .collection('diaries')
          .doc(widget.docID)
          .collection('liked_users')
          .get()
          .then((res) => {
                count = res.docs.length,
                FirebaseFirestore.instance
                    .collection('diaries')
                    .doc(widget.docID)
                    .update({'likes': count})
              });
    }

    void like() {
      FirebaseFirestore.instance
          .collection('diaries')
          .doc(widget.docID)
          .collection('liked_users')
          .doc(currentUser!.uid)
          .set({
        'user_id': currentUser!.uid,
        'post_id': widget.docID,
        'created_at': DateTime.now(),
      });
      updateLikeCount();
    }

    void destroyLike() {
      FirebaseFirestore.instance
          .collection('diaries')
          .doc(widget.docID)
          .collection('liked_users')
          .doc(currentUser!.uid)
          .delete();
      updateLikeCount();
    }

    Widget likeButton = StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('diaries')
            .doc(widget.docID)
            .collection('liked_users')
            .doc(currentUser?.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          bool isLiked;

          // 現在ログイン中のユーザーがいいねを押したかどうかは、例外処理で判定
          try {
            snapshot.data["user_id"];
            isLiked = true;
          } catch (_) {
            isLiked = false;
          }

          if (!snapshot.hasData) {
            //
            return const SizedBox();
          }
          if (snapshot.hasError) {
            //
            return const Text('Something went wrong');
          }

          if (currentUser == null) {
            return IconButton(
              padding: EdgeInsets.all(0.0),
              icon: const Icon(Icons.star_border_outlined, size: 30),
              color: Colors.orange,
              onPressed: () {},
            );
          }

          if (!isLiked) {
            return IconButton(
              padding: EdgeInsets.all(0.0),
              icon: const Icon(Icons.star_border_outlined, size: 30),
              color: Colors.orange,
              onPressed: () {
                like();
              },
            );
          }

          return IconButton(
            padding: EdgeInsets.all(0.0),
            icon: const Icon(Icons.star, size: 30),
            color: Colors.orange,
            onPressed: () {
              destroyLike();
            },
          );
        });

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.data["user_id"])
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
                  title: Text(widget.data["title"]),
                  subtitle: Text(snapshot.data['name']),
                ),
                if (widget.data["image_url"] != null)
                  Container(
                      alignment: Alignment.center,
                      child: Image.network(widget.data["image_url"]!)),
                ButtonTheme(
                  child: ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: [
                          likeButton,
                          Text(
                            widget.data["likes"].toString(),
                            style: TextStyle(
                                height: 0.5,
                                fontSize: 12,
                                color: Colors.black87),
                          )
                        ],
                      ),
                      if (currentUser?.uid == widget.data['user_id'])
                        Column(
                          children: [
                            IconButton(
                              padding: EdgeInsets.all(0.0),
                              icon: const Icon(Icons.edit, size: 30),
                              color: Colors.deepOrangeAccent,
                              onPressed: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.black12,
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return EditDiary(
                                          data: widget.data,
                                          docID: widget.docID);
                                    });
                              },
                            ),
                            Text(
                              '編集',
                              style: TextStyle(
                                  height: 0.5,
                                  fontSize: 12,
                                  color: Colors.black87),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      widget.data["content"],
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
