import 'package:flutter/material.dart';
import "components.dart";
import "conjugate_logic.dart";
import 'package:latin/models/components.dart';
import 'package:latin/models/word.dart';
import 'package:latin/models/tag.dart';

Column conjugateStartDivision(BuildContext context) {
  return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
    ElevatedButton(
        onPressed: () async {
          List<String> tmpTagData = List.from(tagData.values);
          tmpTagData.add("タグなし");
          currentTagData =
              await selectItems(context, tmpTagData, currentTagData, "タグ絞り込み");
        },
        child: const Text("タグ絞り込み")),
    const SizedBox(height: 20),
    ElevatedButton(
        onPressed: () async {
          currentNumData =
              await selectItems(context, numList, currentNumData, "変化系絞り込み");
        },
        child: const Text("変化絞り込み")),
    const SizedBox(height: 20),
    ElevatedButton(
      onPressed: () {
        bool result = resetCurrentWordData();
        if (!result) {
          showAlertDialog(context, "エラー!", "条件に合うワードはありません。絞り込みの設定を見直してみてください");
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ConjugateQuestion(title: "活用テスト")),
          );
        }
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: const Text('活用テスト'),
    ),
  ]);
}

class ConjugateQuestion extends StatefulWidget {
  const ConjugateQuestion(
      {super.key,
      required this.title,
      this.numList = const [],
      this.questionNum = 15});

  final String title;
  final List<String> numList;
  final int questionNum;

  @override
  State<ConjugateQuestion> createState() =>
      _ConjugateQuestionState(numList, questionNum);
}

class _ConjugateQuestionState extends State<ConjugateQuestion> {
  List<String> numList;
  int questionNum; // TODO: questionNumの使用
  _ConjugateQuestionState(this.numList, this.questionNum);

  @override
  Widget build(BuildContext context) {
    Word word = getNextWord();
    NounConjugateType con = getRandomNounConjugateType();
    MultiType mt = getRandomMultiType();
    if (con == NounConjugateType.nom && mt == MultiType.single) {
      mt = MultiType.multi;
    }
    SexType st = word.sex;
    String correctWord = getNounConjugate(word, con, mt, st);
    List<String> words = getRandomConjugated(word, st);
    bool answered = false;
    if (!words.contains(correctWord)) {
      words.removeAt(0);
      words.add(correctWord);
      words.shuffle();
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
              stringToIcon("$currentIdx/${currentWordData.length}",
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
            SingleChildScrollView(
                child: Center(
                    child: Wrap(
                        spacing: 8.0, // ボタン間のスペース
                        runSpacing: 8.0, // 行間のスペース
                        children: List.generate(
                          words.length,
                          (index) => ElevatedButton(
                              // TODO: answeredのボタンごとの個別化
                              onPressed: () {
                                answered = true;
                                if (words[index] == correctWord) {
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
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
                        )))),
          ],
        ),
      ),
    );
  }
}
