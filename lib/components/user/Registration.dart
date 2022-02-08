import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// アカウント登録ページ
class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String name = "";
  String email = "";
  String password = "";
  String infoText = "";
  bool isValid = false;

  final FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? result;
  User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 30.0),
                child: Text('新規アカウントの作成',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            Padding(
                padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: "ユーザー名"),
                  onChanged: (String value) {
                    name = value;
                  },
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    email = value;
                  },
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
              child: TextFormField(
                  decoration: InputDecoration(labelText: "パスワード（8～20文字）"),
                  obscureText: true,
                  maxLength: 20,
                  onChanged: (String value) {
                    if (value.length >= 8) {
                      password = value;
                      isValid = true;
                    } else {
                      isValid = false;
                    }
                  }),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
              child: Text(
                infoText,
                style: TextStyle(color: Colors.red),
              ),
            ),
            ButtonTheme(
              minWidth: 350.0,
              child: ElevatedButton(
                child: Text(
                  '登録',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  if (isValid) {
                    try {
                      // メール/パスワードでユーザー登録
                      await auth
                          .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          )
                          .then((res) => {res.user!.updateDisplayName(name)});

                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(result!.user!.uid)
                          .set({
                        'uid': result!.user!.uid,
                        'name': name,
                        'created_at': DateTime.now()
                      });

                      Navigator.pop(context);
                    } catch (e) {
                      setState(() {
                        debugPrint("registration failed");
                      });
                    }
                  } else {
                    setState(() {
                      infoText = 'パスワードは8文字以上です。';
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
