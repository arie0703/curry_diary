import 'package:curry_app/components/BottomSheetTemplate.dart';
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

class PostDiary extends StatefulWidget {
  const PostDiary({Key? key}) : super(key: key);
  @override
  _PostDiaryState createState() => _PostDiaryState();
}

class _PostDiaryState extends State<PostDiary> {
  String title = "";
  String content = "";
  User? currentUser = FirebaseAuth.instance.currentUser;

  String doc = FirebaseFirestore.instance
      .collection('diaries')
      .doc()
      .id; //ランダム生成されるdocumentIDを事前に取得

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> postDiary(title, content, selectedImage) async {
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
    }

    FirebaseFirestore.instance.collection('diaries').doc(doc).set({
      'title': title,
      'content': content,
      'image_url': imageURL,
      'likes': 0,
      'created_at': DateTime.now(),
      'user_id': currentUser!.uid
    });
  }

  @override
  Widget build(BuildContext context) {
    File? _selectedImage =
        Provider.of<ImageStatus>(context, listen: false).selectedImage;

    Widget _newPost = Column(
      children: [
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
                          icon: const Icon(Icons.remove, color: Colors.grey),
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
                      borderSide:
                          BorderSide(color: (Colors.orange[800])!, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.remove, color: Colors.grey),
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
              ImageUploader(),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  child: const Text('投稿する'),
                  style: ElevatedButton.styleFrom(
                      primary: CommonColor.primaryColor),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      postDiary(title, content, _selectedImage);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ]))
      ],
    );

    return BottomSheetTemplate(title: "カレー日記を投稿", body: _newPost);
  }
}
