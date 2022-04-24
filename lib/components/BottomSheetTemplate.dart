import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomSheetTemplate extends StatefulWidget {
  const BottomSheetTemplate({Key? key, required this.title, required this.body})
      : super(key: key);
  final String title;
  final Widget body;
  @override
  _BottomSheetTemplateState createState() => _BottomSheetTemplateState();
}

class _BottomSheetTemplateState extends State<BottomSheetTemplate> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    double _windowHeight = MediaQuery.of(context).size.height * 0.9;

    return Container(
        height: _windowHeight,
        child: Column(
          children: [
            // header
            Container(
                padding: const EdgeInsets.all(10),
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(widget.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ))),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ])),
            // body
            Container(
                height: _windowHeight - 60,
                padding: const EdgeInsets.all(10),
                color: CommonColor.primaryColor[100],
                child: widget.body)
          ],
        ));
  }
}
