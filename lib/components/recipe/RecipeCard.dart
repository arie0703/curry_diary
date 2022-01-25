import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: CommonColor.primaryColor[50],
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Sample Curry'),
            subtitle: Text('India Curry'),
          ),
          Container(
              alignment: Alignment.center,
              child: Image.asset('assets/sample.jpg')),
          Column(
            children: [Text("カレールー"), Text("ご飯"), Text("福神漬け")],
          ),
        ],
      ),
    );
  }
}
