import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';
import 'package:curry_app/components/diary/Diaries.dart';
import 'package:curry_app/components/diary/PostDiary.dart';
import 'package:curry_app/components/recipe/Recipes.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(color: CommonColor.primaryColor[100]);
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'マイカリー日記',
              theme: ThemeData(
                primarySwatch: CommonColor.primaryColor,
                scaffoldBackgroundColor: CommonColor.primaryColor[100],
              ),
              home: const MyHomePage(title: 'みんなのカレー'),
            );
          }

          return const CircularProgressIndicator();
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedNavContent = 0;
  int _selectedPage = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
      if (index < 3) {
        _selectedNavContent = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pageList = <Widget>[
      Diaries(),
      Recipes(),
    ];

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(child: _pageList.elementAt(_selectedPage)),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("みんなのカレー"),
              trailing: Icon(Icons.list),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("レシピ"),
              trailing: Icon(Icons.food_bank),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              backgroundColor: Colors.black12,
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return PostDiary();
              });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
