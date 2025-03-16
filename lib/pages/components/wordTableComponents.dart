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

  // 画面サイズを取得
  final screenSize = MediaQuery.of(context).size;

  // ポップアップのサイズ
  const popupWidth = 300.0;
  const popupHeight = 250.0;

  // X座標の調整（左右の境界チェック）
  double adjustedX = position.dx - 100;
  if (adjustedX < 0) {
    adjustedX = 10; // 左端に余白を設ける
  } else if (adjustedX + popupWidth > screenSize.width) {
    adjustedX = screenSize.width - popupWidth - 10; // 右端に余白を設ける
  }

  // Y座標の調整（下端の境界チェック）
  double adjustedY = position.dy;
  if (adjustedY + popupHeight > screenSize.height) {
    adjustedY = screenSize.height - popupHeight - 10; // 下端に余白を設ける
  }

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Positioned(
        top: adjustedY,
        left: adjustedX,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            CustomPaint(
              size: const Size(popupWidth, popupHeight),
              painter: PentagonPainter(),
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  if (word.type == WordType.verb)
                    ElevatedButton(
                      onPressed: () async {
                        overlayEntry?.remove(); // 一時的にポップアップを非表示
                        await _showModeFormTenseSelection(context);
                        overlayState.insert(overlayEntry!); // ポップアップを再表示
                      },
                      child: const Text('変更'),
                    ),
                  const SizedBox(height: 10),
                  Table(
                    columnWidths: const {
                      0: FixedColumnWidth(50), // 一列目の幅を50に
                      1: FixedColumnWidth(80), // 二列目の幅は80のまま
                      2: FixedColumnWidth(80), // 三列目の幅は80のまま
                    },
                    border: TableBorder.all(),
                    children: [
                      _generateHeaderRow(["", "Single", "Multi"]),
                      ..._generateConjugateRows(
                          overlayEntry!, word, assignFunction),
                    ],
                  ),
                ],
              ),
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

Future<void> _showModeFormTenseSelection(BuildContext context) async {
  await showDialog(
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
      ..color = Colors.white // 背景色を白に変更
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
