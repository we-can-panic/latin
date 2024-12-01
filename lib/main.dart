import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:latin/pages/sentence_page.dart';
import "package:latin/pages/conjugate_page.dart";
import "package:latin/pages/word_page.dart";

import 'package:latin/apps/io.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // DBからデータを読み込み
  await loadAssets();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Counter(),
        child: MaterialApp(
          darkTheme: ThemeData.dark(),
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: "Monospace, メイリオ",
          ),
          home: const Home(title: 'おかたがかゆかゆキングダム'),
        ));
  }
}

// ---

class Counter extends ChangeNotifier {
  int count = 0;

  void increment() {
    count++;
    notifyListeners();
  }
}

// ---

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              conjugateStartDivision(context),
              sentenceStartDivision(context),
              wordStartDivision(context),
            ]),
          ],
        ),
      ),
    );
  }
}
