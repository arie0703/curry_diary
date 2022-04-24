import 'package:curry_app/components/TermsOfService.dart';
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
  bool isReadTerms = false;

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
            const Padding(
                padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 30.0),
                child: Text('新規アカウントの作成',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "ユーザー名"),
                  onChanged: (String value) {
                    name = value;
                  },
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    email = value;
                  },
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
              child: TextFormField(
                  decoration: const InputDecoration(labelText: "パスワード（8～20文字）"),
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
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
              child: Text(
                infoText,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    isReadTerms = true;
                  });
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return TermsOfService();
                      });
                },
                child: const Text("利用規約")),
            SizedBox(
                width: 300.0,
                height: 50.0,
                child: isReadTerms
                    ? ElevatedButton(
                        child: const Text(
                          '規約に同意して登録',
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
                                  .then((res) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(res.user!.uid)
                                    .set({
                                  'uid': res.user!.uid,
                                  'name': name,
                                  'created_at': DateTime.now()
                                });
                                res.user?.updateDisplayName(name);
                                Navigator.pop(context);
                              });
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          } else {
                            setState(() {
                              infoText = 'パスワードは8文字以上です。';
                            });
                          }
                        },
                      )
                    : ElevatedButton(
                        child: const Text(
                          '規約をお読みください',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}
