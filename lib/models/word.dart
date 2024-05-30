import 'dart:math';
// Noun, verbともに共通のクラス

class Word {
  String la;
  String en;
  String num;
  int idx;

  Word(
      {required this.la,
      required this.en,
      required this.num,
      required this.idx});
}

// 数: 単数、複数
enum Numbers { single, multi }

// 単語の数
String numbersToString(Numbers multiType) {
  switch (multiType) {
    case Numbers.single:
      return "単数";
    case Numbers.multi:
      return "複数";
  }
}

Numbers getRandomNumbers() {
  return Numbers.values[random.nextInt(Numbers.values.length)];
}

Random random = Random();
