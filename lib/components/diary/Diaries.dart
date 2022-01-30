import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curry_app/components/diary/DiaryCard.dart';

class Diaries extends StatefulWidget {
  const Diaries({Key? key}) : super(key: key);
  @override
  _DiariesState createState() => _DiariesState();
}

class _DiariesState extends State<Diaries> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('diaries')
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
        return ListView(
          // リストで表示

          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
            return DiaryCard(
                title: data['title'],
                content: data['content'],
                imageURL: data['image_url']);
          }).toList(),
        );
      },
    );
  }
}
