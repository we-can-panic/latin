// 吹き出しウィンドウの表示用メソッド
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latin/apps/sentence_logic.dart';
import 'package:latin/models/enumeration.dart' as latType;

// 動詞の変化
latType.Mode _mode = latType.Mode.indicative;
latType.Form _form = latType.Form.active;
latType.Tense _tense = latType.Tense.present;
// 名詞の変化はなし

void showWordTable(BuildContext context, Offset position, NounOrVerb word,
    void Function(NounOrVerb) assignFunction) {
  OverlayState overlayState = Overlay.of(context);
  OverlayEntry? overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Positioned(
        top: position.dy,
        left: position.dx - 100,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            CustomPaint(
              size: const Size(300, 250),
              painter: PentagonPainter(),
            ),
            Column(
              children: [
                if (word.type == WordType.verb)
                  ElevatedButton(
                    onPressed: () => _showModeFormTenseSelection(context),
                    child: const Text('変更'),
                  ),
                const SizedBox(height: 10),
                Table(
                  defaultColumnWidth: const FixedColumnWidth(80),
                  border: TableBorder.all(),
                  children: [
                    _generateHeaderRow(["", "Single", "Multi"]),
                    ..._generateConjugateRows(
                        overlayEntry!, word, assignFunction),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    },
  );

  overlayState.insert(overlayEntry);
}

TableRow _generateHeaderRow(List<String> cells) {
  return TableRow(
    children: cells.map((cell) {
      return _generateCell(Text(
        cell,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ));
    }).toList(),
  );
}

List<TableRow> _generateConjugateRows(OverlayEntry overlayEntry,
    NounOrVerb word, void Function(NounOrVerb) assignFunction) {
  List<TableRow> result = [];
  switch (word.type) {
    case WordType.noun:
      for (var c in latType.NounCase.values) {
        List<Widget> cells = [];
        cells.add(_generateCell(_generateText(c.name)));
        for (var n in latType.Numbers.values) {
          cells.add(
            _generateCell(ElevatedButton(
              // 格/数を更新
              onPressed: () {
                NounOrVerb assignWord = word;
                assignWord.nounComponent.nounCase = c;
                assignWord.nounComponent.num = n;
                assignFunction(assignWord);
                overlayEntry.remove();
              },
              child: _generateText(word.nounComponent.noun.conjugate(c, n)),
            )),
          );
        }
        result.add(TableRow(children: cells));
      }
      break;
    case WordType.verb:
      for (var p in latType.Person.values) {
        List<Widget> cells = [];
        cells.add(_generateCell(_generateText(p.name)));
        for (var n in latType.Numbers.values) {
          cells.add(
            _generateCell(ElevatedButton(
              // 人称/数を更新
              onPressed: () {
                NounOrVerb assignWord = word;
                assignWord.verbComponent.person = p;
                assignWord.verbComponent.num = n;
                assignFunction(assignWord);
                overlayEntry.remove();
              },
              child: _generateText(word.verbComponent.verb.conjugate(
                // m, f, t, p, num
                word.verbComponent.mode,
                word.verbComponent.form,
                word.verbComponent.tense,
                p,
                n,
              )),
            )),
          );
        }
        result.add(TableRow(children: cells));
      }
      break;
  }
  return result;
}

Widget _generateCell(Widget w) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Center(child: w),
  );
}

Widget _generateText(String txt) {
  return Text(
    txt,
    style: const TextStyle(
      fontSize: 14,
    ),
  );
}

void _showModeFormTenseSelection(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      latType.Mode tempMode = _mode;
      latType.Form tempForm = _form;
      latType.Tense tempTense = _tense;

      return AlertDialog(
        title: const Text('法・態・時制の選択'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField(
              value: tempMode,
              items: const [
                DropdownMenuItem(
                    value: latType.Mode.indicative, child: Text("indicative")),
                DropdownMenuItem(
                    value: latType.Mode.inperative, child: Text("imperative")),
                DropdownMenuItem(
                    value: latType.Mode.subjunctive,
                    child: Text("subjunctive")),
              ],
              onChanged: (value) => tempMode = value!,
              decoration: const InputDecoration(labelText: '法'),
            ),
            DropdownButtonFormField(
              value: tempForm,
              items: const [
                DropdownMenuItem(
                    value: latType.Form.active, child: Text("active")),
                DropdownMenuItem(
                    value: latType.Form.passive, child: Text("passive")),
              ],
              onChanged: (value) => tempForm = value!,
              decoration: const InputDecoration(labelText: '態'),
            ),
            DropdownButtonFormField(
              value: tempTense,
              items: const [
                DropdownMenuItem(
                    value: latType.Tense.present, child: Text("present")),
                DropdownMenuItem(
                    value: latType.Tense.past, child: Text("past")),
              ],
              onChanged: (value) => tempTense = value!,
              decoration: const InputDecoration(labelText: '時制'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              _mode = tempMode;
              _form = tempForm;
              _tense = tempTense;
              Navigator.pop(context);
            },
            child: const Text('確定'),
          ),
        ],
      );
    },
  );
}

class PentagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final path = Path();
    const double radius = 100;
    const double angle = (2 * pi) / 5;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < 5; i++) {
      final x = centerX + radius * cos(i * angle - pi / 2);
      final y = centerY + radius * sin(i * angle - pi / 2);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
