import 'package:flutter/material.dart';
import "package:latin/pages/components/wordTableComponents.dart";
import "components/components.dart";
import "../apps/sentence_logic.dart";

Column sentenceStartDivision(BuildContext context) {
  return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
    ElevatedButton(
      onPressed: () {
        resetCurrentSentenceData();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const SentenceQuestion(title: "文章テスト")),
        );
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
            // selected
            SingleChildScrollView(
                child: Center(
                    child: Wrap(
                        spacing: 8.0, // ボタン間のスペース
                        runSpacing: 8.0, // 行間のスペース
                        children: List.generate(
                            selectedWords.length,
                            (index) => GestureDetector(
                                  onLongPressStart: (details) {
                                    showWordTable(
                                      context,
                                      details.globalPosition,
                                      selectedWords[index],
                                      (word) => setState(
                                          () => selectedWords[index] = word),
                                    );
                                  },
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          NounOrVerb nv = selectedWords[index];
                                          selectedWords.removeAt(index);
                                          candidateWords.add(nv);
                                        });
                                      },
                                      child: Text(
                                          getQuestion(selectedWords[index]),
                                          style:
                                              const TextStyle(fontSize: 18))),
                                ))))),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            // candidate
            SingleChildScrollView(
                child: Center(
                    child: Wrap(
                        spacing: 8.0, // ボタン間のスペース
                        runSpacing: 8.0, // 行間のスペース
                        children: List.generate(
                            candidateWords.length,
                            (index) => GestureDetector(
                                  onLongPressStart: (details) {
                                    showWordTable(
                                      context,
                                      details.globalPosition,
                                      candidateWords[index],
                                      (word) => setState(
                                          () => candidateWords[index] = word),
                                    );
                                  },
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          NounOrVerb nv = candidateWords[index];
                                          candidateWords.removeAt(index);
                                          selectedWords.add(nv);
                                        });
                                      },
                                      child: Text(
                                          getQuestion(candidateWords[index]),
                                          style:
                                              const TextStyle(fontSize: 18))),
                                ))))),
            const Expanded(child: SizedBox()),
            ElevatedButton(
              onPressed: () {
                if (isCorrect(sentence, selectedWords)) {
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
