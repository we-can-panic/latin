import 'package:flutter/material.dart';
import 'package:latin/models/tag.dart';
import "components.dart";
import "sentence_logic.dart";

Column sentenceStartDivision(BuildContext context) {
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
      onPressed: () {
        bool result = resetCurrentSentenceData();
        if (!result) {
          showAlertDialog(context, "エラー!", "条件に合うワードはありません。絞り込みの設定を見直してみてください");
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SentenceQuestion(title: "文章テスト")),
          );
        }
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: const Text('文章テスト'),
    ),
  ]);
}

class SentenceQuestion extends StatefulWidget {
  const SentenceQuestion({super.key, required this.title});

  final String title;

  @override
  State<SentenceQuestion> createState() => _SentenceQuestionState();
}

class _SentenceQuestionState extends State<SentenceQuestion> {
  _SentenceQuestionState();

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
                    sentence.en,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            stringToIcon("$currentIdx/${currentSentenceData.length}",
                style: StyleType.info),
            const SizedBox(height: 50),
            SingleChildScrollView(
                child: Center(
                    child: Wrap(
                        spacing: 8.0, // ボタン間のスペース
                        runSpacing: 8.0, // 行間のスペース
                        children: List.generate(
                          selectedWords.length,
                          (index) => ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  candidateWords.add(selectedWords[index]);
                                  selectedWords.removeAt(index);
                                });
                              },
                              child: Text(selectedWords[index].la,
                                  style: const TextStyle(fontSize: 18))),
                        )))),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            SingleChildScrollView(
                child: Center(
                    child: Wrap(
                        spacing: 8.0, // ボタン間のスペース
                        runSpacing: 8.0, // 行間のスペース
                        children: List.generate(
                          candidateWords.length,
                          (index) => ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedWords.add(candidateWords[index]);
                                  candidateWords.removeAt(index);
                                });
                              },
                              child: Text(candidateWords[index].la,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18))),
                        )))),
            const Expanded(child: SizedBox()),
            ElevatedButton(
              onPressed: () {
                Set<String> selected =
                    Set<String>.from(selectedWords.map((w) => w.la));
                Set<String> correct =
                    Set<String>.from(sentence.wordComponents.map((w) => w.la));
                if (selected.containsAll(correct) &&
                    correct.containsAll(selected)) {
                  setState(() {
                    moveNext();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100, 30),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Icon(Icons.check),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
