import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curry_app/components/recipe/EditRecipe.dart';

class RecipeDetail extends StatefulWidget {
  const RecipeDetail(
      {Key? key,
      required this.data,
      required this.userName,
      required this.docID})
      : super(key: key);
  final Map data;
  final String userName;
  final String docID;
  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    double _windowHeight = MediaQuery.of(context).size.height * 0.9;

    void updateLikeCount() async {
      int count = 0;

      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.docID)
          .collection('liked_users')
          .get()
          .then((res) => {
                count = res.docs.length,
                FirebaseFirestore.instance
                    .collection('recipes')
                    .doc(widget.docID)
                    .update({'likes': count})
              });
    }

    void like() {
      FirebaseFirestore.instance
          .collection('recipes')
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
          .collection('recipes')
          .doc(widget.docID)
          .collection('liked_users')
          .doc(currentUser!.uid)
          .delete();
      updateLikeCount();
    }

    Widget _likeButton = StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('recipes')
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
              padding: const EdgeInsets.all(0.0),
              icon: const Icon(Icons.star_border_outlined, size: 30),
              color: Colors.orange,
              onPressed: () {},
            );
          }

          if (!isLiked) {
            return IconButton(
              padding: const EdgeInsets.all(0.0),
              icon: const Icon(Icons.star_border_outlined, size: 30),
              color: Colors.orange,
              onPressed: () {
                like();
              },
            );
          }

          return IconButton(
            padding: const EdgeInsets.all(0.0),
            icon: const Icon(Icons.star, size: 30),
            color: Colors.orange,
            onPressed: () {
              destroyLike();
            },
          );
        });

    Widget _editButton = IconButton(
      padding: EdgeInsets.all(0.0),
      icon: const Icon(Icons.edit, size: 30),
      color: Colors.deepOrangeAccent,
      onPressed: () {
        showModalBottomSheet(
            backgroundColor: Colors.black12,
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return EditRecipe(data: widget.data, docID: widget.docID);
            });
        // FirebaseFirestore.instance
        //     .collection('recipes')
        //     .doc(widget.docID)
        //     .delete();
      },
    );

    Widget _infoBar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.data['title'], style: const TextStyle(fontSize: 25)),
            Text('by ' + widget.userName),
          ],
        ),
        Row(
          children: [
            if (currentUser?.uid == widget.data['user_id'])
              Column(
                children: [
                  _editButton,
                  const Text('編集',
                      style: TextStyle(
                          height: 0.5, fontSize: 12, color: Colors.black87))
                ],
              ),
            Column(
              children: [
                _likeButton,
                const Text('いいね!',
                    style: TextStyle(
                        height: 0.5, fontSize: 12, color: Colors.black87))
              ],
            )
          ],
        ),
      ],
    );

    return Container(
        height: _windowHeight,
        child: Column(
          children: [
            // header
            Container(
                padding: const EdgeInsets.all(10),
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(widget.data["title"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ))),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ])),
            // body
            Container(
                height: _windowHeight - 60,
                color: CommonColor.primaryColor[100],
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.data["image_url"] != null
                          ? Image.network(widget.data["image_url"])
                          : Image.asset('assets/noimage.png',
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover),
                      Container(
                          margin: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoBar,
                              Text(
                                widget.data['content'],
                                style:
                                    const TextStyle(fontSize: 18, height: 2.0),
                              ),
                              for (int i = 0;
                                  i < widget.data['procedure'].length;
                                  i++)
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: const EdgeInsets.only(bottom: 6.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.brown[400]!,
                                            width: 1.0)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text((i + 1).toString()),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Flexible(
                                          child:
                                              Text(widget.data['procedure'][i]))
                                    ],
                                  ),
                                )
                            ],
                          )),
                    ],
                  ),
                ))
          ],
        ));
  }
}
