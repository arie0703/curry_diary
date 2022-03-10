import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curry_app/components/diary/DiaryCard.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDiaries extends StatefulWidget {
  const UserDiaries({Key? key}) : super(key: key);
  @override
  _UserDiariesState createState() => _UserDiariesState();
}

class _UserDiariesState extends State<UserDiaries> {
  String userName = '';
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('diaries')
          .where('user_id', isEqualTo: currentUser!.uid)
          .orderBy('created_at', descending: true)
          .snapshots(), //streamでデータの追加とかを監視する
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          //データがないときの処理
          return const Center(
            child: SizedBox(),
          );
        }
        if (snapshot.hasError) {
          //
          return const Text('Something went wrong');
        }
        return Column(
          children: snapshot.data!.docs.map(
            (doc) {
              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

              return DiaryCard(
                  title: data['title'],
                  content: data['content'],
                  imageURL: data['image_url'],
                  likes: data['likes'],
                  userID: data['user_id'],
                  docID: doc.id);
            },
          ).toList(),
        );
      },
    );
  }
}
