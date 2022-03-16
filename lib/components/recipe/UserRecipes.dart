import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curry_app/components/Recipe/RecipeCard.dart';

class UserRecipes extends StatefulWidget {
  const UserRecipes({Key? key}) : super(key: key);
  @override
  _UserRecipesState createState() => _UserRecipesState();
}

class _UserRecipesState extends State<UserRecipes> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('recipes')
          .where('user_id', isEqualTo: currentUser!.uid)
          .orderBy('created_at', descending: true)
          .snapshots(), //streamでデータの追加とかを監視する
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          //
          return const Text('Something went wrong');
        }
        return Column(
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
