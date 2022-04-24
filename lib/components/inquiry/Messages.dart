import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key, required this.deviceId}) : super(key: key);
  final String deviceId;
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('inquiries')
          .where('sender_id',
              isEqualTo:
                  currentUser != null ? currentUser!.uid : widget.deviceId)
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

        return Expanded(
          child: ListView(
            // リストで表示
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(data["title"]),
                      subtitle: Text(data["content"]),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("メッセージを削除"),
                                content: const Text("削除しますか？"),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("yes"),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('inquiries')
                                          .doc(doc.id)
                                          .delete();

                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  if (data['reply'] != null) // 返答を表示
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListTile(
                        title: const Text("運営からの返答"),
                        subtitle: Text(data['reply']),
                        leading: const Icon(Icons.person),
                      ),
                    )
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
