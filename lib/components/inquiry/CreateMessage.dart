import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:curry_app/CustomClass.dart';

class CreateMessage extends StatefulWidget {
  const CreateMessage({Key? key, required this.deviceId}) : super(key: key);
  final String deviceId;
  @override
  _CreateMessageState createState() => _CreateMessageState();
}

class _CreateMessageState extends State<CreateMessage> {
  String title = "";
  String content = "";

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String doc = FirebaseFirestore.instance
      .collection('inquiries')
      .doc()
      .id; //ランダム生成されるdocumentIDを事前に取得
  final _formKey = GlobalKey<FormState>();
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    double _windowHeight = MediaQuery.of(context).size.height * 0.9;
    return Container(
      height: _windowHeight,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(10),
              height: 60,
              decoration: BoxDecoration(
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
                        child: Text("お問い合わせ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ))),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ])),
          Container(
            height: _windowHeight - 60,
            padding: EdgeInsets.all(10),
            color: CommonColor.primaryColor[100],
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                                hintText: 'お問い合わせ内容',
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.orange, width: 2.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                suffixIcon: IconButton(
                                    icon:
                                        Icon(Icons.remove, color: Colors.grey),
                                    onPressed: () {
                                      titleController.clear();
                                      title = "";
                                    })),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'お問い合わせ内容を入力してください';
                              }
                              return null;
                            },
                            onChanged: (text) {
                              title = text;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            controller: contentController,
                            decoration: InputDecoration(
                                hintText: 'メッセージ',
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.orange, width: 2.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                suffixIcon: IconButton(
                                    icon:
                                        Icon(Icons.remove, color: Colors.grey),
                                    onPressed: () {
                                      contentController.clear();
                                      content = "";
                                    })),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'お問い合わせ内容を入力してください';
                              }
                              return null;
                            },
                            onChanged: (text) {
                              content = text;
                            },
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    child: Text('送信'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await FirebaseFirestore.instance
                            .collection('inquiries') // コレクションID
                            .doc(doc) // ドキュメントID
                            .set({
                          'title': title,
                          'sender_id': currentUser != null
                              ? currentUser?.uid
                              : widget.deviceId,
                          'content': content,
                          'reply': null,
                          'created_at': DateTime.now()
                        }); // データ

                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
