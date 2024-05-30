import 'package:flutter/material.dart';
import 'package:latin/models/noun.dart';
import 'package:latin/models/noun_utils.dart';
import 'package:latin/models/meta_utils.dart';
import "components.dart";
import "word_logic.dart";

Column wordStartDivision(BuildContext context) {
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
          String res = await selectItem(
              context, ["英語", "ラテン語"], questionByLa ? "ラテン語" : "英語", "出題言語選択");
          questionByLa = res == "ラテン語";
        },
        child: const Text("出題言語選択")),
    const SizedBox(height: 20),
    ElevatedButton(
      onPressed: () {
        bool result = resetCurrentNounData();
        if (!result) {
          showAlertDialog(context, "エラー!", "条件に合うワードはありません。絞り込みの設定を見直してみてください");
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const WordQuestion(title: "単語テスト")),
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

class WordQuestion extends StatefulWidget {
  const WordQuestion({super.key, required this.title});

  final String title;

  @override
  State<WordQuestion> createState() => _WordQuestionState();
}

class _WordQuestionState extends State<WordQuestion> {
  _WordQuestionState();

  @override
  Widget build(BuildContext context) {
    Noun word = getNextNoun();
    bool answered = false;
    List<Noun> candidateNouns = getRandomNouns();
    if (!candidateNouns.map((item) => item.en).contains(word.en)) {
      candidateNouns[0] = word;
    }
    candidateNouns
        .sort((a, b) => toAnswer(a).compareTo(toAnswer(b))); // アルファベット順にソート

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
                    toQuestion(word),
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            stringToIcon("$currentIdx/${currentNounData.length}",
                style: StyleType.info),
            const SizedBox(height: 20),
            SingleChildScrollView(
                child: Center(
                    child: Wrap(
                        spacing: 8.0, // ボタン間のスペース
                        runSpacing: 8.0, // 行間のスペース
                        children: List.generate(
                          candidateNouns.length,
                          (index) => ElevatedButton(
                              // TODO: answeredのボタンごとの個別化
                              onPressed: () {
                                answered = true;
                                if (candidateNouns[index].en == word.en) {
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
                                } else if (candidateNouns[index].en ==
                                    word.en) {
                                  // 正解の場合は薄緑色の背景に緑の枠を適用
                                  return Colors.lightGreenAccent;
                                  // 不正解のボタンを選んでいたら灰色
                                } else {
                                  return Colors.grey.shade700;
                                }
                              })),
                              child: Text(toAnswer(candidateNouns[index]),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18))),
                        )))),
          ],
        ),
      ),
    );
  }
}
