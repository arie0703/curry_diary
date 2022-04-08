import 'package:curry_app/components/ImageUploader.dart';
import 'package:flutter/material.dart';
import 'package:curry_app/ImageStatus.dart';
import 'package:provider/provider.dart';
import 'package:curry_app/CustomClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class EditDiary extends StatefulWidget {
  const EditDiary({Key? key, required this.data, required this.docID})
      : super(key: key);
  final Map data;
  final String docID;
  @override
  _EditDiaryState createState() => _EditDiaryState();
}

class _EditDiaryState extends State<EditDiary> {
  String title = "";
  String content = "";
  User? currentUser = FirebaseAuth.instance.currentUser;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _EditDiary(title, content, selectedImage) async {
    String? imageURL;

    if (selectedImage != null) {
      String filePath = basename(selectedImage.path);
      FirebaseStorage storage = FirebaseStorage.instance;

      UploadTask uploadTask = storage
          .ref()
          .child('uploads/')
          .child(filePath)
          .putFile(selectedImage);

      // 画像URLを取得
      await uploadTask.then((res) async {
        await res.ref.getDownloadURL().then((res) {
          imageURL = res.toString();
        });
      });
    } else {
      imageURL = widget.data["image_url"];
    }

    FirebaseFirestore.instance.collection('diaries').doc(widget.docID).set({
      'title': title,
      'content': content,
      'image_url': imageURL,
      'likes': widget.data["likes"],
      'created_at': DateTime.now(),
      'user_id': currentUser!.uid
    });
  }

  @override
  void initState() {
    title = widget.data['title'];
    content = widget.data['content'];
    _titleController = TextEditingController(text: widget.data["title"]);
    _contentController = TextEditingController(text: widget.data["content"]);
  }

  Widget build(BuildContext context) {
    File? _selectedImage =
        Provider.of<ImageStatus>(context, listen: false).selectedImage;

    return Scaffold(
      body: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.only(
            top: 100,
          ),
          child: ListView(
            children: [
              const Text(
                "カレー日記を編集",
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
                          controller: _titleController,
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
                                  _titleController.clear();
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
                        controller: _contentController,
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
                                _contentController.clear();
                                content = "";
                              }),
                        ),
                        onChanged: (text) {
                          content = text;
                        },
                      ),
                    ),
                    ImageUploader(),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        child: const Text('編集する'),
                        style: ElevatedButton.styleFrom(
                            primary: CommonColor.primaryColor),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _EditDiary(title, content, _selectedImage);
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: TextButton(
                        child: const Text(
                          '削除する',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return AlertDialog(
                                backgroundColor: CommonColor.primaryColor[50],
                                title: Text("削除"),
                                content: Text("投稿を削除しますが、よろしいですか？"),
                                actions: [
                                  TextButton(
                                    child: Text("いいえ"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: Text("はい"),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('diaries')
                                          .doc(widget.docID)
                                          .delete();
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ]))
            ],
          )),
    );
  }
}
