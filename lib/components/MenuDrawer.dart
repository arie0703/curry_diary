import 'package:curry_app/components/user/Login.dart';
import 'package:curry_app/components/user/Registration.dart';
import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key, required this.onItemTapped}) : super(key: key);

  final Function onItemTapped;

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: CommonColor.primaryColor[50],
      child: ListView(
        children: [
          if (currentUser == null)
            ListTile(
              title: const Text("ゲストさん"),
              subtitle: Row(
                children: [
                  TextButton(
                      child: const Text("ログイン"),
                      onPressed: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            backgroundColor: Colors.black12,
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Login();
                            });
                      }),
                  TextButton(
                      child: const Text("会員登録"),
                      onPressed: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Registration();
                            });
                      })
                ],
              ),
              leading: const Icon(Icons.person),
            )
          else
            ListTile(
              title: Text(currentUser!.displayName ?? "未設定"),
              subtitle: Row(
                children: [
                  TextButton(
                      child: const Text("マイページ"),
                      onPressed: () {
                        widget.onItemTapped(2);
                        Navigator.pop(context);
                      }),
                  TextButton(
                      child: const Text("ログアウト"),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      }),
                ],
              ),
              leading: const Icon(Icons.person),
            ),
          ListTile(
            title: const Text("みんなのカレー"),
            leading: const Icon(Icons.list),
            onTap: () {
              widget.onItemTapped(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("レシピ"),
            leading: const Icon(Icons.food_bank),
            onTap: () {
              widget.onItemTapped(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("お問い合わせ"),
            leading: const Icon(Icons.help),
            onTap: () {
              widget.onItemTapped(3);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ));
  }
}
