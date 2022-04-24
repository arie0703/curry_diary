import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:curry_app/ImageStatus.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:curry_app/components/ImageUploader.dart';
import 'package:curry_app/CustomClass.dart';

class EditUser extends StatefulWidget {
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  String? name = "";
  String? email = "";

  UserCredential? result;
  User? user;

  Future<void> _editUser(name, email, selectedImage) async {
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
          debugPrint(imageURL);
          currentUser!.updatePhotoURL(imageURL);
        });
      });
    } else {
      imageURL = currentUser!.photoURL;
    }

    FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).set({
      'uid': currentUser!.uid,
      'name': name,
      'image_url': imageURL,
      'email': email,
    });

    currentUser!.updateDisplayName(name);
    currentUser!.updateEmail(email);
  }

  @override
  void initState() {
    super.initState();
    name = currentUser!.displayName;
    email = currentUser!.email;
  }

  Widget build(BuildContext context) {
    double _windowHeight = MediaQuery.of(context).size.height * 0.9;
    File? _selectedImage =
        Provider.of<ImageStatus>(context, listen: false).selectedImage;

    return Container(
      height: _windowHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(10),
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                        child: Text('ユーザー情報の編集',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white))),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ])),
          Container(
              height: _windowHeight - 60,
              color: CommonColor.primaryColor[100],
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                      child: TextFormField(
                        initialValue: currentUser!.displayName,
                        decoration: const InputDecoration(labelText: "ユーザー名"),
                        onChanged: (String value) {
                          name = value;
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                      child: TextFormField(
                        initialValue: currentUser!.email,
                        decoration: const InputDecoration(labelText: "メールアドレス"),
                        onChanged: (String value) {
                          email = value;
                        },
                      )),
                  ImageUploader(),
                  ButtonTheme(
                    minWidth: 350.0,
                    child: ElevatedButton(
                      child: const Text(
                        '更新',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        _editUser(name, email, _selectedImage);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
