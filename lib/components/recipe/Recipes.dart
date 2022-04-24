import 'package:curry_app/components/recipe/PostRecipe.dart';
import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curry_app/components/Recipe/RecipeCard.dart';

class Recipes extends StatefulWidget {
  const Recipes({Key? key}) : super(key: key);
  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('recipes')
          .orderBy('created_at', descending: true)
          .snapshots(), //streamでデータの追加とかを監視する
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          //データがないときの処理
          return const Center(
            child: Text("error"),
          );
        }
        if (snapshot.hasError) {
          //
          return const Text('Something went wrong');
        }
        return ListView(
          cacheExtent: 250.0 * 5.0,
          // リストで表示

          children: snapshot.data!.docs.map(
            (doc) {
              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

              return RecipeCard(data: data, docID: doc.id);
            },
          ).toList(),
        );
      },
    );
  }
}
