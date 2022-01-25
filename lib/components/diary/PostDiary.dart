import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDiary extends StatefulWidget {
  const PostDiary({Key? key}) : super(key: key);
  @override
  _PostDiaryState createState() => _PostDiaryState();
}

class _PostDiaryState extends State<PostDiary> {
  String title = "";
  String content = "";

  String doc = FirebaseFirestore.instance
      .collection('diaries')
      .doc()
      .id; //ランダム生成されるdocumentIDを事前に取得

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.only(
            top: 100,
          ),
          child: Column(
            children: [
              const Text(
                "カレー日記を投稿する",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'タイトル',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: (Colors.orange[700])!, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.remove,
                                    color: Colors.grey),
                                onPressed: () {
                                  titleController.clear();
                                  title = "";
                                }),
                          ),
                          onChanged: (text) {
                            title = text;
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        controller: contentController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'コメント',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: (Colors.orange[800])!, width: 2.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          suffixIcon: IconButton(
                              icon:
                                  const Icon(Icons.remove, color: Colors.grey),
                              onPressed: () {
                                contentController.clear();
                                content = "";
                              }),
                        ),
                        onChanged: (text) {
                          content = text;
                        },
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: Container(
                              child: Icon(Icons.photo, color: Colors.grey),
                              margin: EdgeInsets.all(10),
                              height: 150,
                              width: 150,
                              color: CommonColor.primaryColor[50]),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        child: const Text('投稿する'),
                        style: ElevatedButton.styleFrom(
                            primary: CommonColor.primaryColor),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await FirebaseFirestore.instance
                                .collection('diaries')
                                .doc(doc)
                                .set({
                              'title': title,
                              'content': content,
                              'created_at': DateTime.now()
                            });

                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ]))
            ],
          )),
    );
  }
}
