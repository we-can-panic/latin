import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:latin/models/word.dart';
import 'package:latin/models/sentence.dart';

List<Sentence> sentenceData = [];
List<WordMeta> wordMetaData = [];
List<SentenceMeta> sentenceMetaData = [];
Map<int, String> tagData = {};

const List<String> numList = ["1", "2", "3", "3i"];

// --
// App関数

List<String> getTag(Word word) {
  for (var m in wordMetaData) {
    if (m.wordIdx == word.idx) {
      return m.tags;
    }
  }
  return [];
}

List<String> getTagOfSentence(Sentence sentence) {
  for (var m in sentenceMetaData) {
    if (m.sentenceIdx == sentence.idx) {
      return m.tags;
    }
  }
  return [];
}

// ランダムな数/格の単語をいくつか返す
List<String> getRandomConjugated(Word word, SexType s, {int size = 5}) {
  List<String> allCandidate = [];
  for (var m in MultiType.values) {
    for (var c in NounConjugateType.values) {
      allCandidate.add(getNounConjugate(word, c, m, s));
    }
  }

  allCandidate = allCandidate.toSet().toList();
  allCandidate.shuffle();

  return allCandidate.sublist(0, size);
}

// 前処理
Future<void> init() async {
  String wordStr = await rootBundle.loadString('assets/word.json');
  String sentenceStr = await rootBundle.loadString('assets/sentence.json');
  String wordMetaStr = await rootBundle.loadString('assets/word_meta.json');
  String sentenceMetaStr =
      await rootBundle.loadString('assets/sentence_meta.json');
  String tagStr = await rootBundle.loadString("assets/tags.json");

  List<dynamic> word = jsonDecode(wordStr);
  List<dynamic> sentence = jsonDecode(sentenceStr);
  List<dynamic> wordMeta = jsonDecode(wordMetaStr);
  List<dynamic> sentenceMeta = jsonDecode(sentenceMetaStr);
  List<dynamic> tag = jsonDecode(tagStr);

  wordData = word.map((json) => Word.fromJson(json)).toList();
  sentenceData = sentence.map((json) => Sentence.fromJson(json)).toList();
  tagData = tagDataFromJson(tag);
  wordMetaData =
      wordMeta.map((json) => WordMeta.fromJson(json, tag: tagData)).toList();
  sentenceMetaData = sentenceMeta
      .map((json) => SentenceMeta.fromJson(json, tag: tagData))
      .toList();

  wordData.shuffle();
}

// --
// クラス

/// input: [{id: 1, name: tag1}, {id: 2, name: tag2}]
/// output: {1: tag1, 2: tag2}
Map<int, String> tagDataFromJson(List<dynamic> json) {
  Map<int, String> result = {};
  for (var data in json) {
    int id = data["id"];
    String name = data["name"];
    result[id] = name;
  }
  return result;
}

// --
// Middle関数

List<Word> getRandomWords({int num = 7}) {
  List<Word> words = List.from(wordData);
  words.shuffle();
  return words.sublist(0, 7).toList();
}

// ランダム
NounConjugateType getRandomNounConjugateType() {
  List<NounConjugateType> list = NounConjugateType.values;
  int randomIndex = random.nextInt(list.length);
  return list[randomIndex];
}

MultiType getRandomMultiType() {
  List<MultiType> list = MultiType.values;
  int randomIndex = random.nextInt(list.length);
  return list[randomIndex];
}

// 単語の活用
String getNounConjugate(
    Word word, NounConjugateType w, MultiType m, SexType s) {
  switch (word.num) {
    case '1': // a
      String stem = word.la.substring(0, word.la.length - 1);
      Map<MultiType, Map<NounConjugateType, String>> map = {
        MultiType.single: {
          NounConjugateType.nom: "a",
          NounConjugateType.gen: "ae",
          NounConjugateType.dat: "ae",
          NounConjugateType.acc: "am",
          NounConjugateType.abl: "ā",
        },
        MultiType.multi: {
          NounConjugateType.nom: "ae",
          NounConjugateType.gen: "ārum",
          NounConjugateType.dat: "īs",
          NounConjugateType.acc: "ās",
          NounConjugateType.abl: "īs",
        }
      };
      return stem + map[m]![w]!;
    case '2': // us, um, er
      String stem = "";
      if (word.la.endsWith("er")) {
        if (w == NounConjugateType.nom && m == MultiType.single) {
          return word.la;
        }
        List<String> liberList = [
          "liber",
          "asper",
          "miser",
          "prosper",
          "tener"
        ];
        if (liberList.contains(word.la)) {
          stem = word.la;
        } else {
          stem = "${word.la.substring(0, word.la.length - 2)}r";
        }
      } else {
        stem = word.la.substring(0, word.la.length - 2);
      }
      if (s == SexType.m) {
        Map<MultiType, Map<NounConjugateType, String>> map = {
          MultiType.single: {
            NounConjugateType.nom: "us",
            NounConjugateType.gen: "ī",
            NounConjugateType.dat: "ō",
            NounConjugateType.acc: "um",
            NounConjugateType.abl: "ō",
          },
          MultiType.multi: {
            NounConjugateType.nom: "ī",
            NounConjugateType.gen: "ōrum",
            NounConjugateType.dat: "īs",
            NounConjugateType.acc: "ōs",
            NounConjugateType.abl: "īs",
          }
        };
        return stem + map[m]![w]!;
      } else {
        Map<MultiType, Map<NounConjugateType, String>> map = {
          MultiType.single: {
            NounConjugateType.nom: "um",
            NounConjugateType.gen: "ī",
            NounConjugateType.dat: "ō",
            NounConjugateType.acc: "um",
            NounConjugateType.abl: "ō",
          },
          MultiType.multi: {
            NounConjugateType.nom: "a",
            NounConjugateType.gen: "ārum",
            NounConjugateType.dat: "īs",
            NounConjugateType.acc: "a",
            NounConjugateType.abl: "īs",
          }
        };
        return stem + map[m]![w]!;
      }
    case '3': // homō. leō, lex, genus, caput, nomen, canis
      if (w == NounConjugateType.nom && m == MultiType.single) {
        return word.la;
      }
      // 男性か女性ならhomō, leō, lex, canis
      if (s == SexType.f || s == SexType.m) {
        String stem = "";
        if (word.la.endsWith("is")) {
          stem = word.la.substring(0, word.la.length - 2);
          // 末尾がxならlex
        } else if (word.la[word.la.length - 1] == "x") {
          stem = "${word.la.substring(0, word.la.length - 1)}g";
          // 2番目が母音ならleo
        } else if ("aiueoāīūēō".contains(word.la[word.la.length - 2])) {
          stem = "${word.la}n";
          // 子音ならhomo
        } else {
          stem = "${word.la.substring(0, word.la.length - 1)}in";
        }
        Map<MultiType, Map<NounConjugateType, String>> map = {
          MultiType.single: {
            NounConjugateType.nom: "",
            NounConjugateType.gen: "is",
            NounConjugateType.dat: "ī",
            NounConjugateType.acc: "em",
            NounConjugateType.abl: "e",
          },
          MultiType.multi: {
            NounConjugateType.nom: "ēs",
            NounConjugateType.gen: "um",
            NounConjugateType.dat: "ibus",
            NounConjugateType.acc: "ēs",
            NounConjugateType.abl: "ibus",
          }
        };
        return stem + map[m]![w]!;
      } else {
        // genus, caput, nomen
        if ((m == MultiType.single) &&
            (w == NounConjugateType.nom || w == NounConjugateType.acc)) {
          return word.la;
        }
        String stem = "";
        switch (word.la.substring(word.la.length - 2, word.la.length)) {
          case "ut":
            stem = "${word.la.substring(0, word.la.length - 2)}it";
            break;
          case "us":
            stem = "${word.la.substring(0, word.la.length - 2)}or";
            break;
          case "en":
            stem = "${word.la.substring(0, word.la.length - 2)}in";
            break;
          default:
            stem = word.la;
        }
        Map<MultiType, Map<NounConjugateType, String>> map = {
          MultiType.single: {
            NounConjugateType.nom: "",
            NounConjugateType.gen: "is",
            NounConjugateType.dat: "ī",
            NounConjugateType.acc: "",
            NounConjugateType.abl: "e",
          },
          MultiType.multi: {
            NounConjugateType.nom: "a",
            NounConjugateType.gen: "um",
            NounConjugateType.dat: "ibus",
            NounConjugateType.acc: "a",
            NounConjugateType.abl: "ibus",
          }
        };
        return stem + map[m]![w]!;
      }
    case '3i': // ignis, animal, feles, calcar
      if (m == MultiType.single && w == NounConjugateType.nom) {
        return word.la;
      }
      // is, es, s, -(er), -(al, ar), e
      if (word.la.endsWith("is")) {
        String stem = word.la.substring(0, word.la.length - 2);
        Map<MultiType, Map<NounConjugateType, String>> map = {
          MultiType.single: {
            NounConjugateType.nom: "is",
            NounConjugateType.gen: "is",
            NounConjugateType.dat: "ī",
            NounConjugateType.acc: "im",
            NounConjugateType.abl: "ī",
          },
          MultiType.multi: {
            NounConjugateType.nom: "ēs",
            NounConjugateType.gen: "ium",
            NounConjugateType.dat: "ibus",
            NounConjugateType.acc: "īs",
            NounConjugateType.abl: "ibus",
          }
        };
        return stem + map[m]![w]!;
      } else if (word.la.endsWith("es") || word.la.endsWith("ēs")) {
        String stem = word.la.substring(0, word.la.length - 2);
        Map<MultiType, Map<NounConjugateType, String>> map = {
          MultiType.single: {
            NounConjugateType.nom: "ēs",
            NounConjugateType.gen: "is",
            NounConjugateType.dat: "ī",
            NounConjugateType.acc: "em",
            NounConjugateType.abl: "e",
          },
          MultiType.multi: {
            NounConjugateType.nom: "ēs",
            NounConjugateType.gen: "ium",
            NounConjugateType.dat: "ibus",
            NounConjugateType.acc: "is",
            NounConjugateType.abl: "ibus",
          }
        };
        return stem + map[m]![w]!;
      } else if (word.la.endsWith("s")) {
        String stem = word.la.substring(0, word.la.length - 1);
        Map<MultiType, Map<NounConjugateType, String>> map = {
          MultiType.single: {
            NounConjugateType.nom: "s",
            NounConjugateType.gen: "is",
            NounConjugateType.dat: "ī",
            NounConjugateType.acc: "em",
            NounConjugateType.abl: "e",
          },
          MultiType.multi: {
            NounConjugateType.nom: "ēs",
            NounConjugateType.gen: "ium",
            NounConjugateType.dat: "ibus",
            NounConjugateType.acc: "is",
            NounConjugateType.abl: "ibus",
          }
        };
        return stem + map[m]![w]!;
      } else if (word.la.endsWith("er")) {
        String stem = "${word.la.substring(0, word.la.length - 2)}r";
        Map<MultiType, Map<NounConjugateType, String>> map = {
          MultiType.single: {
            NounConjugateType.nom: "er",
            NounConjugateType.gen: "is",
            NounConjugateType.dat: "ī",
            NounConjugateType.acc: "em",
            NounConjugateType.abl: "e",
          },
          MultiType.multi: {
            NounConjugateType.nom: "ēs",
            NounConjugateType.gen: "ium",
            NounConjugateType.dat: "ibus",
            NounConjugateType.acc: "īs",
            NounConjugateType.abl: "ibus",
          }
        };
        return stem + map[m]![w]!;
      } else if (["al", "āl", "ar", "ār"]
          .contains(word.la.substring(word.la.length - 2, word.la.length))) {
        if (m == MultiType.single && w == NounConjugateType.acc) {
          return word.la;
        }
        String stem = word.la.endsWith("al")
            ? "${word.la.substring(0, word.la.length - 2)}āl"
            : word.la.endsWith("ar")
                ? "${word.la.substring(0, word.la.length - 2)}ār"
                : word.la;
        Map<MultiType, Map<NounConjugateType, String>> map = {
          MultiType.single: {
            NounConjugateType.nom: "",
            NounConjugateType.gen: "is",
            NounConjugateType.dat: "ī",
            NounConjugateType.acc: "",
            NounConjugateType.abl: "ī",
          },
          MultiType.multi: {
            NounConjugateType.nom: "ia",
            NounConjugateType.gen: "ium",
            NounConjugateType.dat: "ibus",
            NounConjugateType.acc: "ia",
            NounConjugateType.abl: "ibus",
          }
        };
        return stem + map[m]![w]!;
      } else {
        // mare
        String stem = word.la.substring(0, word.la.length - 2);
        Map<MultiType, Map<NounConjugateType, String>> map = {
          MultiType.single: {
            NounConjugateType.nom: "e",
            NounConjugateType.gen: "is",
            NounConjugateType.dat: "ī",
            NounConjugateType.acc: "e",
            NounConjugateType.abl: "ī",
          },
          MultiType.multi: {
            NounConjugateType.nom: "ia",
            NounConjugateType.gen: "ium",
            NounConjugateType.dat: "ibus",
            NounConjugateType.acc: "ia",
            NounConjugateType.abl: "ibus",
          }
        };
        return stem + map[m]![w]!;
      }
    default:
      return "<Unknown word>: ${word.la}${word.num}";
  }
}

// --

Random random = Random();
