import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curry_app/components/diary/UserDiaries.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
            padding: EdgeInsets.only(top: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    currentUser!.displayName ?? "未設定",
                    style: TextStyle(fontSize: 20.0, height: 2.0),
                  ),
                  Container(
                    width: 110.0,
                    height: 110.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/noimage.png"))),
                  ),
                  TextButton(child: Text("設定"), onPressed: () {}),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [Text("カレー"), Text("0")],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [Text("レシピ"), Text("0")],
                        ),
                      ),
                    ],
                  ),
                  UserDiaries(),
                ],
              ),
            )));
  }
}
