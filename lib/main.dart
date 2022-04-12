import 'package:curry_app/ImageStatus.dart';
import 'package:curry_app/UserStatus.dart';
import 'package:curry_app/components/MenuDrawer.dart';
import 'package:curry_app/components/recipe/PostRecipe.dart';
import 'package:curry_app/components/user/Login.dart';
import 'package:curry_app/components/user/MyPage.dart';
import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';
import 'package:curry_app/components/diary/Diaries.dart';
import 'package:curry_app/components/diary/PostDiary.dart';
import 'package:curry_app/components/recipe/Recipes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ImageStatus()),
      ChangeNotifierProvider(create: (_) => UserStatus()),
    ], child: const MyApp()),
  );
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
  User? currentUser = FirebaseAuth.instance.currentUser;

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
      // _selectedNavContentはBottomNavigationBarのindexとして使用する
      if (index < 2) {
        _selectedNavContent = index;
      }
    });
  }

  List<Widget> _titleList = <Widget>[
    Text("みんなのカレー"),
    Text("レシピ"),
    Text("マイページ")
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> _pageList = <Widget>[
      Diaries(),
      Recipes(),
      MyPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: _titleList[_selectedPage],
        actions: [
          if (_selectedPage == 0)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'カレー日記を投稿',
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.black12,
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      if (currentUser == null) {
                        return Login();
                      }
                      return PostDiary();
                    });
              },
            ),
          if (_selectedPage == 1)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'レシピを投稿',
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.black12,
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      if (currentUser == null) {
                        return Login();
                      }
                      return PostRecipe();
                    });
              },
            ),
        ],
      ),
      body: Center(child: _pageList.elementAt(_selectedPage)),
      drawer: MenuDrawer(onItemTapped: _onItemTapped),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange[50],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'カレー日記',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'レシピ',
          ),
        ],
        currentIndex: _selectedNavContent,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
      ),
    );
  }
}
