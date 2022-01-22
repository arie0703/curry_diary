import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';

class PostCard extends StatelessWidget {
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
          ButtonTheme(
            child: ButtonBar(
              children: <Widget>[
                ElevatedButton(
                  child: const Text('レシピを見る'),
                  onPressed: () {
                    debugPrint("button pressed");
                  },
                ),
                ElevatedButton(
                  child: const Text('いいね'),
                  onPressed: () {
                    debugPrint("button pressed");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
