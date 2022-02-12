import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiaryCard extends StatefulWidget {
  const DiaryCard({
    Key? key,
    required this.title,
    required this.content,
    this.imageURL,
    required this.likes,
    required this.userID,
    required this.docID,
  }) : super(key: key);
  final String title;
  final String content;
  final String? imageURL;
  final int likes;
  final String userID;
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
            .doc(currentUser!.uid)
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
                      Column(
                        children: [
                          IconButton(
                            padding: EdgeInsets.all(0.0),
                            icon: const Icon(Icons.book_sharp, size: 30),
                            color: Colors.orange[800],
                            onPressed: () {
                              debugPrint("button pressed");
                            },
                          ),
                          Text(
                            'レシピ',
                            style: TextStyle(
                                height: 0.5,
                                fontSize: 12,
                                color: Colors.black87),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          likeButton,
                          Text(
                            widget.likes.toString(),
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
              ],
            ),
          );
        });
  }
}
