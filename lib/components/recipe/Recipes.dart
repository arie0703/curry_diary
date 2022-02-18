import 'package:curry_app/components/recipe/PostRecipe.dart';
import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';
import 'package:curry_app/components/Recipe/RecipeCard.dart';

class Recipes extends StatefulWidget {
  const Recipes({Key? key}) : super(key: key);
  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  @override
  Widget build(BuildContext context) {
    return (Center(
      child: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Colors.black12,
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return PostRecipe();
                  });
            },
            child: Text("add"),
          ),
          RecipeCard(),
          RecipeCard()
        ],
      ),
    ));
  }
}
