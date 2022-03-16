import 'package:curry_app/components/recipe/UserRecipes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curry_app/components/diary/UserDiaries.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  // 0 -> curry : 1 -> recipe
  int _selectedIndex = 0;

  var _selectedTextStyle = TextStyle();

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
                      // ListTile(
                      //   title: Text("カレー"),
                      //   subtitle: Text("0"),
                      //   onTap: () {
                      //     setState(() {
                      //       _selectedIndex = 0;
                      //     });
                      //   },
                      // ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            "カレー\n0",
                            style: TextStyle(
                                fontWeight: _selectedIndex == 0
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            "レシピ\n0",
                            style: TextStyle(
                                fontWeight: _selectedIndex == 1
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                      visible: _selectedIndex == 0, child: UserDiaries()),
                  Visibility(
                      visible: _selectedIndex == 1, child: UserRecipes()),
                ],
              ),
            )));
  }
}
