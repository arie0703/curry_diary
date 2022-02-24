import 'package:curry_app/components/recipe/RecipeDetail.dart';
import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({Key? key, required this.data, required this.docID})
      : super(key: key);
  final Map data;
  final String docID;
  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.data['user_id'])
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(),
            );
          }
          if (snapshot.hasError) {
            //
            return const Text('Something went wrong');
          }
          return GestureDetector(
            onTap: () {
              BuildContext mainContext = context;
              showModalBottomSheet(
                  backgroundColor: CommonColor.primaryColor[100],
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return RecipeDetail(
                      data: widget.data,
                      userName: snapshot.data['name'],
                      docID: widget.docID,
                    );
                  });
            },
            child: Card(
                color: CommonColor.primaryColor[50],
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        padding: EdgeInsets.only(right: 10),
                        child: widget.data["imageURL"] != null
                            ? Image.network(widget.data["imageURL"])
                            : Image.asset('assets/noimage.png',
                                fit: BoxFit.cover),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.data["title"],
                              style: TextStyle(
                                  fontSize: 20,
                                  color: CommonColor.primaryColor[800])),
                          Text("by " + snapshot.data['name'],
                              style: TextStyle(height: 1.5)),
                          Text(widget.data['ingredients'].join(","),
                              style: TextStyle(height: 2.0))
                        ],
                      ),
                    ],
                  ),
                )),
          );
        });
  }
}
