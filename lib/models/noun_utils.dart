import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'noun.dart';
import 'word.dart';

List<Noun> nounData = []; // 全てのNounデータ

const List<String> numList = ["1", "2", "3", "3i"];

Future<void> loadNounData() async {
  String nounStr = await rootBundle.loadString('assets/noun.json');
  List<dynamic> noun = jsonDecode(nounStr);
  nounData = noun.map((json) => Noun.fromJson(json)).toList();
}

// --
// Util関数

// 特定のidxのnounを取得
Noun getNounByIdx(int idx) {
  for (var w in nounData) {
    if (idx == w.idx) {
      return w;
    }
  }
  return Noun(
      la: "", en: "", type: NounType.noun, num: "1", sex: SexType.f, idx: -1);
}

List<Noun> getRandomNouns({int num = 7}) {
  List<Noun> nouns = List.from(nounData);
  nouns.shuffle();
  return nouns.sublist(0, num).toList();
}

// ランダム
NounConjugateType getRandomNounConjugateType() {
  List<NounConjugateType> list = NounConjugateType.values;
  int randomIndex = random.nextInt(list.length);
  return list[randomIndex];
}

// 単語の活用
String getNounConjugate(Noun noun, NounConjugateType w, Numbers m, SexType s) {
  switch (noun.num) {
    case '1': // a
      String stem = noun.la.substring(0, noun.la.length - 1);
      Map<Numbers, Map<NounConjugateType, String>> map = {
        Numbers.single: {
          NounConjugateType.nom: "a",
          NounConjugateType.gen: "ae",
          NounConjugateType.dat: "ae",
          NounConjugateType.acc: "am",
          NounConjugateType.abl: "ā",
        },
        Numbers.multi: {
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
      if (noun.la.endsWith("er")) {
        if (w == NounConjugateType.nom && m == Numbers.single) {
          return noun.la;
        }
        List<String> liberList = [
          "liber",
          "asper",
          "miser",
          "prosper",
          "tener"
        ];
        if (liberList.contains(noun.la)) {
          stem = noun.la;
        } else {
          stem = "${noun.la.substring(0, noun.la.length - 2)}r";
        }
      } else {
        stem = noun.la.substring(0, noun.la.length - 2);
      }
      if (s == SexType.m) {
        Map<Numbers, Map<NounConjugateType, String>> map = {
          Numbers.single: {
            NounConjugateType.nom: "us",
            NounConjugateType.gen: "ī",
            NounConjugateType.dat: "ō",
            NounConjugateType.acc: "um",
            NounConjugateType.abl: "ō",
          },
          Numbers.multi: {
            NounConjugateType.nom: "ī",
            NounConjugateType.gen: "ōrum",
            NounConjugateType.dat: "īs",
            NounConjugateType.acc: "ōs",
            NounConjugateType.abl: "īs",
          }
        };
        return stem + map[m]![w]!;
      } else {
        Map<Numbers, Map<NounConjugateType, String>> map = {
          Numbers.single: {
            NounConjugateType.nom: "um",
            NounConjugateType.gen: "ī",
            NounConjugateType.dat: "ō",
            NounConjugateType.acc: "um",
            NounConjugateType.abl: "ō",
          },
          Numbers.multi: {
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
      if (w == NounConjugateType.nom && m == Numbers.single) {
        return noun.la;
      }
      // 男性か女性ならhomō, leō, lex, canis
      if (s == SexType.f || s == SexType.m) {
        String stem = "";
        if (noun.la.endsWith("is")) {
          stem = noun.la.substring(0, noun.la.length - 2);
          // 末尾がxならlex
        } else if (noun.la[noun.la.length - 1] == "x") {
          stem = "${noun.la.substring(0, noun.la.length - 1)}g";
          // 2番目が母音ならleo
        } else if ("aiueoāīūēō".contains(noun.la[noun.la.length - 2])) {
          stem = "${noun.la}n";
          // 子音ならhomo
        } else {
          stem = "${noun.la.substring(0, noun.la.length - 1)}in";
        }
        Map<Numbers, Map<NounConjugateType, String>> map = {
          Numbers.single: {
            NounConjugateType.nom: "",
            NounConjugateType.gen: "is",
            NounConjugateType.dat: "ī",
            NounConjugateType.acc: "em",
            NounConjugateType.abl: "e",
          },
          Numbers.multi: {
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
        if ((m == Numbers.single) &&
            (w == NounConjugateType.nom || w == NounConjugateType.acc)) {
          return noun.la;
        }
        String stem = "";
        switch (noun.la.substring(noun.la.length - 2, noun.la.length)) {
          case "ut":
            stem = "${noun.la.substring(0, noun.la.length - 2)}it";
            break;
          case "us":
            stem = "${noun.la.substring(0, noun.la.length - 2)}or";
            break;
          case "en":
            stem = "${noun.la.substring(0, noun.la.length - 2)}in";
            break;
          default:
            stem = noun.la;
        }
        Map<Numbers, Map<NounConjugateType, String>> map = {
          Numbers.single: {
            NounConjugateType.nom: "",
            NounConjugateType.gen: "is",
            NounConjugateType.dat: "ī",
            NounConjugateType.acc: "",
            NounConjugateType.abl: "e",
          },
          Numbers.multi: {
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
      if (m == Numbers.single && w == NounConjugateType.nom) {
        return noun.la;
      }
      // is, es, s, -(er), -(al, ar), e
      if (noun.la.endsWith("is")) {
        String stem = noun.la.substring(0, noun.la.length - 2);
        Map<Numbers, Map<NounConjugateType, String>> map = {
          Numbers.single: {
            NounConjugateType.nom: "is",
            NounConjugateType.gen: "is",
            NounConjugateType.dat: "ī",
            NounConjugateType.acc: "im",
            NounConjugateType.abl: "ī",
          },
          Numbers.multi: {
            NounConjugateType.nom: "ēs",
            NounConjugateType.gen: "ium",
            NounConjugateType.dat: "ibus",
            NounConjugateType.acc: "īs",
            NounConjugateType.abl: "ibus",
          }
        };
        return stem + map[m]![w]!;
      } else if (noun.la.endsWith("es") || noun.la.endsWith("ēs")) {
        String stem = noun.la.substring(0, noun.la.length - 2);
        Map<Numbers, Map<NounConjugateType, String>> map = {
          Numbers.single: {
            NounConjugateType.nom: "ēs",
            NounConjugateType.gen: "is",
            NounConjugateType.dat: "ī",
            NounConjugateType.acc: "em",
            NounConjugateType.abl: "e",
          },
          Numbers.multi: {
            NounConjugateType.nom: "ēs",
            NounConjugateType.gen: "ium",
            NounConjugateType.dat: "ibus",
            NounConjugateType.acc: "is",
            NounConjugateType.abl: "ibus",
          }
        };
        return stem + map[m]![w]!;
      } else if (noun.la.endsWith("s")) {
        String stem = noun.la.substring(0, noun.la.length - 1);
        Map<Numbers, Map<NounConjugateType, String>> map = {
          Numbers.single: {
            NounConjugateType.nom: "s",
            NounConjugateType.gen: "is",
            NounConjugateType.dat: "ī",
            NounConjugateType.acc: "em",
            NounConjugateType.abl: "e",
          },
          Numbers.multi: {
            NounConjugateType.nom: "ēs",
            NounConjugateType.gen: "ium",
            NounConjugateType.dat: "ibus",
            NounConjugateType.acc: "is",
            NounConjugateType.abl: "ibus",
          }
        };
        return stem + map[m]![w]!;
      } else if (noun.la.endsWith("er")) {
        String stem = "${noun.la.substring(0, noun.la.length - 2)}r";
        Map<Numbers, Map<NounConjugateType, String>> map = {
          Numbers.single: {
            NounConjugateType.nom: "er",
            NounConjugateType.gen: "is",
            NounConjugateType.dat: "ī",
            NounConjugateType.acc: "em",
            NounConjugateType.abl: "e",
          },
          Numbers.multi: {
            NounConjugateType.nom: "ēs",
            NounConjugateType.gen: "ium",
            NounConjugateType.dat: "ibus",
            NounConjugateType.acc: "īs",
            NounConjugateType.abl: "ibus",
          }
        };
        return stem + map[m]![w]!;
      } else if (["al", "āl", "ar", "ār"]
          .contains(noun.la.substring(noun.la.length - 2, noun.la.length))) {
        if (m == Numbers.single && w == NounConjugateType.acc) {
          return noun.la;
        }
        String stem = noun.la.endsWith("al")
            ? "${noun.la.substring(0, noun.la.length - 2)}āl"
            : noun.la.endsWith("ar")
                ? "${noun.la.substring(0, noun.la.length - 2)}ār"
                : noun.la;
        Map<Numbers, Map<NounConjugateType, String>> map = {
          Numbers.single: {
            NounConjugateType.nom: "",
            NounConjugateType.gen: "is",
            NounConjugateType.dat: "ī",
            NounConjugateType.acc: "",
            NounConjugateType.abl: "ī",
          },
          Numbers.multi: {
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
        String stem = noun.la.substring(0, noun.la.length - 2);
        Map<Numbers, Map<NounConjugateType, String>> map = {
          Numbers.single: {
            NounConjugateType.nom: "e",
            NounConjugateType.gen: "is",
            NounConjugateType.dat: "ī",
            NounConjugateType.acc: "e",
            NounConjugateType.abl: "ī",
          },
          Numbers.multi: {
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
      return "<Unknown noun>: ${noun.la}${noun.num}";
  }
}

// ランダムな数/格の単語をいくつか返す
List<String> getRandomConjugated(Noun noun, SexType s, {int size = 5}) {
  List<String> allCandidate = [];
  for (var m in Numbers.values) {
    for (var c in NounConjugateType.values) {
      allCandidate.add(getNounConjugate(noun, c, m, s));
    }
  }

  allCandidate = allCandidate.toSet().toList();
  allCandidate.shuffle();

  return allCandidate.sublist(0, size);
}

Random random = Random();
