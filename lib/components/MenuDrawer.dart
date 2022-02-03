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
              title: Text("ゲストさん"),
              subtitle: Row(
                children: [
                  TextButton(
                      child: Text("ログイン"),
                      onPressed: () {
                        widget.onItemTapped(2);
                        Navigator.pop(context);
                      }),
                  TextButton(
                      child: Text("会員登録"),
                      onPressed: () {
                        widget.onItemTapped(3);
                        Navigator.pop(context);
                      })
                ],
              ),
              leading: Icon(Icons.person),
            )
          else
            ListTile(
              title: Text(currentUser!.uid),
              subtitle: Row(
                children: [
                  TextButton(
                      child: Text("ログアウト"),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      })
                ],
              ),
              leading: Icon(Icons.person),
            ),
          ListTile(
            title: Text("みんなのカレー"),
            leading: Icon(Icons.list),
            onTap: () {
              widget.onItemTapped(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("レシピ"),
            leading: Icon(Icons.food_bank),
            onTap: () {
              widget.onItemTapped(1);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ));
  }
}
