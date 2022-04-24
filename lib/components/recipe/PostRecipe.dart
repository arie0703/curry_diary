import 'package:curry_app/components/BottomSheetTemplate.dart';
import 'package:curry_app/components/ImageUploader.dart';
import 'package:curry_app/components/recipe/TextFieldList.dart';
import 'package:flutter/material.dart';
import 'package:curry_app/ImageStatus.dart';
import 'package:provider/provider.dart';
import 'package:curry_app/CustomClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class PostRecipe extends StatefulWidget {
  const PostRecipe({Key? key}) : super(key: key);
  @override
  _PostRecipeState createState() => _PostRecipeState();
}

class _PostRecipeState extends State<PostRecipe> {
  String title = "";
  String content = "";
  List<String> procedure = [""];
  List<String> ingredients = [""];
  bool isVisibleIngredients = false;
  bool isVisibleProcedure = false;
  User? currentUser = FirebaseAuth.instance.currentUser;

  String doc = FirebaseFirestore.instance
      .collection('recipes')
      .doc()
      .id; //ランダム生成されるdocumentIDを事前に取得

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> PostRecipe(title, content, selectedImage) async {
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

    FirebaseFirestore.instance.collection('recipes').doc(doc).set({
      'title': title,
      'content': content,
      'ingredients': ingredients,
      'procedure': procedure,
      'image_url': imageURL,
      'likes': 0,
      'created_at': DateTime.now(),
      'user_id': currentUser!.uid
    });
  }

  // TextFieldを動的に複数描画するWidget

  Future _showDialog(text, list) async {
    await showDialog(
        barrierDismissible: true,
        context: this.context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              backgroundColor: CommonColor.primaryColor[100],
              title: Text(text),
              children: [
                Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(10),
                    child: TextFieldList(list: list))
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    File? _selectedImage =
        Provider.of<ImageStatus>(context, listen: false).selectedImage;

    Widget _newRecipe = ListView(
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
              TextButton(
                child: const Text("材料"),
                onPressed: () async {
                  await _showDialog("材料を追加", ingredients);
                },
              ),
              TextButton(
                child: const Text("つくりかた"),
                onPressed: () async {
                  await _showDialog("つくりかたを追加", procedure);
                },
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
                      PostRecipe(title, content, _selectedImage);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ]))
      ],
    );

    return BottomSheetTemplate(title: "レシピを投稿", body: _newRecipe);
  }
}
