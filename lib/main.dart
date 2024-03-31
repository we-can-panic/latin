import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "latinutils.dart";
import "flutterutils.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
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
          theme: ThemeData.dark(),
          // theme: ThemeData(
          //   primarySwatch: Colors.blue,
          //   fontFamily: "Monospace, メイリオ",
          // ),
          home: const Home(title: 'おかたがかゆかゆキングダム'),
          // routes: {
          //   '/': (context) => const Home(title: 'おかたがかゆかゆキングダム'),
          // '/ConugateQuestion': (context) =>
          //     const ConjugateQuestion(title: ""),
          // '/SentenceQuestion': (context) => const SentenceQuestion(title: ""),
          // '/WordQuestion': (context) => const WordQuestion(title: "")
          // },
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ConjugateQuestion(title: "活用テスト")),
                  );
                },
                child: const Text('活用テスト'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SentenceQuestion(title: "文章テスト")),
                  );
                },
                child: const Text('文章テスト'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const WordQuestion(title: "単語テスト")),
                  );
                },
                child: const Text('単語テスト'),
              )
            ]),
          ],
        ),
      ),
    );
  }
}

// ---

class ConjugateQuestion extends StatefulWidget {
  const ConjugateQuestion({super.key, required this.title});

  final String title;

  @override
  State<ConjugateQuestion> createState() => _ConjugateQuestionState();
}

class _ConjugateQuestionState extends State<ConjugateQuestion> {
  @override
  Widget build(BuildContext context) {
    Word word = getNextWord();
    NounConjugateType con = getRandomNounConjugateType();
    MultiType mt = getRandomMultiType();
    SexType st = word.sex;
    String correctWord = getNounConjugate(word, con, mt, st);
    List<String> words = getRandomConjugated(word, st);
    bool answered = false;
    if (!words.contains(correctWord)) {
      words.add(correctWord);
    }
    words.shuffle();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.lightGreen,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    word.la,
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    word.en,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              stringToIcon("性：${sexTypeToString(st)}", style: StyleType.info),
              const SizedBox(width: 20),
              stringToIcon("格変化：${word.num}", style: StyleType.info),
              const SizedBox(width: 20),
              stringToIcon("$currentIdx/${wordData.length}",
                  style: StyleType.info),
            ]),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: Table(
                // border: TableBorder.all(),
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                          child: Center(
                              child: Text("", style: TextStyle(fontSize: 16)))),
                      TableCell(
                          child: Center(
                              child:
                                  Text("単数", style: TextStyle(fontSize: 16)))),
                      TableCell(
                          child: Center(
                              child:
                                  Text("複数", style: TextStyle(fontSize: 16)))),
                      TableCell(
                          child: Center(
                              child: Text("", style: TextStyle(fontSize: 16)))),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                          child: Center(
                              child:
                                  Text("主格", style: TextStyle(fontSize: 16)))),
                      TableCell(
                        child: Container(
                          width: 100,
                          height: 50,
                          color: mt == MultiType.single &&
                                  con == NounConjugateType.nom
                              ? Colors.lightGreenAccent[400]
                              : Colors.grey[800],
                        ),
                      ),
                      TableCell(
                          child: Container(
                        width: 100,
                        height: 50,
                        color: mt == MultiType.multi &&
                                con == NounConjugateType.nom
                            ? Colors.lightGreenAccent[400]
                            : Colors.grey[800],
                      )),
                      const TableCell(
                          child: SizedBox(
                              width: 50,
                              child: Text("", style: TextStyle(fontSize: 16)))),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                          child: Center(
                              child:
                                  Text("属格", style: TextStyle(fontSize: 16)))),
                      TableCell(
                          child: Container(
                        width: 100,
                        height: 50,
                        color: mt == MultiType.single &&
                                con == NounConjugateType.gen
                            ? Colors.lightGreenAccent[400]
                            : Colors.grey[800],
                      )),
                      TableCell(
                          child: Container(
                        width: 100,
                        height: 50,
                        color: mt == MultiType.multi &&
                                con == NounConjugateType.gen
                            ? Colors.lightGreenAccent[400]
                            : Colors.grey[800],
                      )),
                      const TableCell(
                          child: SizedBox(
                              width: 50,
                              child: Text("", style: TextStyle(fontSize: 16)))),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                          child: Center(
                              child:
                                  Text("与格", style: TextStyle(fontSize: 16)))),
                      TableCell(
                          child: Container(
                        width: 100,
                        height: 50,
                        color: mt == MultiType.single &&
                                con == NounConjugateType.dat
                            ? Colors.lightGreenAccent[400]
                            : Colors.grey[800],
                      )),
                      TableCell(
                          child: Container(
                        width: 100,
                        height: 50,
                        color: mt == MultiType.multi &&
                                con == NounConjugateType.dat
                            ? Colors.lightGreenAccent[400]
                            : Colors.grey[800],
                      )),
                      const TableCell(
                          child: SizedBox(
                              width: 50,
                              child: Text("", style: TextStyle(fontSize: 16)))),
                    ],
                  ),
                  TableRow(children: [
                    const TableCell(
                        child: Center(
                            child: Text("対格", style: TextStyle(fontSize: 16)))),
                    TableCell(
                      child: Container(
                        width: 100,
                        height: 50,
                        color: mt == MultiType.single &&
                                con == NounConjugateType.acc
                            ? Colors.lightGreenAccent[400]
                            : Colors.grey[800],
                      ),
                    ),
                    TableCell(
                        child: Container(
                      width: 100,
                      height: 50,
                      color:
                          mt == MultiType.multi && con == NounConjugateType.acc
                              ? Colors.lightGreenAccent[400]
                              : Colors.grey[800],
                    )),
                    const TableCell(
                        child: SizedBox(
                            width: 50,
                            child: Text("", style: TextStyle(fontSize: 16)))),
                  ]),
                  TableRow(children: [
                    const TableCell(
                        child: Center(
                            child: Text("奪格", style: TextStyle(fontSize: 16)))),
                    TableCell(
                        child: Container(
                      width: 100,
                      height: 50,
                      color:
                          mt == MultiType.single && con == NounConjugateType.abl
                              ? Colors.lightGreenAccent[400]
                              : Colors.grey[800],
                    )),
                    TableCell(
                        child: Container(
                      width: 100,
                      height: 50,
                      color:
                          mt == MultiType.multi && con == NounConjugateType.abl
                              ? Colors.lightGreenAccent[400]
                              : Colors.grey[800],
                    )),
                    const TableCell(
                        child: SizedBox(
                            width: 50,
                            child: Text("", style: TextStyle(fontSize: 16)))),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
                child: Wrap(
                    spacing: 8.0, // ボタン間のスペース
                    runSpacing: 8.0, // 行間のスペース
                    children: List.generate(
                      words.length,
                      (index) => ElevatedButton(
                          onPressed: () {
                            answered = true;
                            if (words[index] == correctWord) {
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                setState(() {});
                              });
                            }
                          },
                          style: ButtonStyle(backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                            if (!answered) {
                              return Colors.white70;
                            } else if (words[index] == correctWord) {
                              // 正解の場合は薄緑色の背景に緑の枠を適用
                              return Colors.lightGreenAccent;
                              // 不正解のボタンを選んでいたら灰色
                            } else {
                              return Colors.grey.shade700;
                            }
                          })),
                          child: Text(words[index],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18))),
                    ))),
          ],
        ),
      ),
    );
  }
}

// ---

class SentenceQuestion extends StatefulWidget {
  const SentenceQuestion({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SentenceQuestion> createState() => _SentenceQuestionState();
}

class _SentenceQuestionState extends State<SentenceQuestion> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the SentenceQuestion object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              // 'You have pushed the button this many times:',
              'You have clicked the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// ---

class WordQuestion extends StatefulWidget {
  const WordQuestion({super.key, required this.title});
  final String title;

  @override
  State<WordQuestion> createState() => _WordQuestionState();
}

class _WordQuestionState extends State<WordQuestion> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ポップなエフェクト'),
      ),
      body: const Center(
        child: PopEffect(),
      ),
    );
  }
}

// --

class PopEffect extends StatefulWidget {
  const PopEffect({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PopEffectState createState() => _PopEffectState();
}

class _PopEffectState extends State<PopEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _opacityAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: const Text(
          '正解',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
