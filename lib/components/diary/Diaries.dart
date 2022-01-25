import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curry_app/components/diary/DiaryCard.dart';

class Diaries extends StatefulWidget {
  const Diaries({Key? key}) : super(key: key);
  @override
  _DiariesState createState() => _DiariesState();
}

class _DiariesState extends State<Diaries> {
  @override
  Widget build(BuildContext context) {
    return (Center(
      child: ListView(
        children: [DiaryCard(), DiaryCard()],
      ),
    ));
  }
}
