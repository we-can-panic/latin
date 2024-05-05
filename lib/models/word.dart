import 'dart:math';

List<Word> wordData = []; // 全てのWordデータ
List<WordMeta> wordMetaData = []; // メタデータ

// 単語の数
const List<String> numList = ["1", "2", "3", "3i"];

// wordクラス
class Word {
  String la;
  String en;
  WordType type;
  String num;
  SexType sex;
  int idx;

  Word(
      {required this.la,
      required this.en,
      required this.type,
      required this.num,
      required this.sex,
      required this.idx});

  // 連想配列からロード
  factory Word.fromJson(Map<String, dynamic> json) {
    // List<Person> people = jsonData.map((json) => Person.fromJson(json)).toList();
    return Word(
      la: json["la"],
      en: json["en"],
      type: wordTypeFromString(json["type"]),
      num: json["num"],
      sex: sexTypeFromString(json["sex"]),
      idx: json["idx"],
    );
  }
}

// 単語タイプ
enum WordType { noun, verb, adjective }

// 単語活用タイプ
enum NounConjugateType { nom, gen, dat, acc, abl }

// 単数か複数
enum MultiType { single, multi }

// 性
enum SexType { f, m, n }

// メタデータクラス
class WordMeta {
  int wordIdx;
  List<int> score;
  List<String> tags;

  WordMeta({required this.wordIdx, required this.tags, required this.score});

  // 連想配列からロード
  factory WordMeta.fromJson(Map<String, dynamic> json,
      {required Map<int, String> tag}) {
    return WordMeta(
      wordIdx: json["wordIdx"],
      score: json["score"].cast<int>(),
      tags: json["tags"]
          .cast<int>()
          .map((tagId) => tag[tagId])
          .cast<String>()
          .toList(),
    );
  }
}

WordType wordTypeFromString(String wordType) {
  Map<String, WordType> wordMap = {
    "noun": WordType.noun,
    "verb": WordType.verb,
    "adjective": WordType.adjective
  };
  WordType? result = wordMap[wordType];
  if (result != null) {
    return result;
  } else {
    return WordType.noun;
  }
}

SexType sexTypeFromString(String sexType) {
  switch (sexType) {
    case "m":
      return SexType.m;
    case "f":
      return SexType.f;
    case "n":
      return SexType.n;
    default:
      return SexType.m;
  }
}

String sexTypeToString(SexType sexType) {
  switch (sexType) {
    case SexType.m:
      return "男性";
    case SexType.f:
      return "女性";
    case SexType.n:
      return "中性";
  }
}

String multiTypeToString(MultiType multiType) {
  switch (multiType) {
    case MultiType.single:
      return "単数";
    case MultiType.multi:
      return "複数";
  }
}

// --
// Util関数

// 特定のidxのwordを取得
Word getWordByIdx(int idx) {
  for (var w in wordData) {
    if (idx == w.idx) {
      return w;
    }
  }
  return Word(
      la: "", en: "", type: WordType.noun, num: "1", sex: SexType.f, idx: -1);
}

// Wordに紐づいているTagを取得
List<String> getTag(Word word) {
  for (var m in wordMetaData) {
    if (m.wordIdx == word.idx) {
      return m.tags;
    }
  }
  return [];
}

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

Random random = Random();
