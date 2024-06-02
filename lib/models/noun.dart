import "../database/database.dart";
import 'word.dart';
import "meta.dart";

// 全てのNounデータ
List<Noun> nounData = [];
const List<String> numList = ["1", "2", "3", "3i"];

// --

// 単語タイプ
enum NounType { noun, verb, adjective }

// 単語活用タイプ
enum NounConjugateType { nom, gen, dat, acc, abl }

// 性
enum SexType { f, m, n }

// wordクラス
class Noun extends Word {
  NounType type;
  SexType sex;

  Noun(
      {required super.la,
      required super.en,
      required this.type,
      required super.num,
      required this.sex,
      required super.idx,
      required super.meta});

  // 連想配列からロード
  factory Noun.fromJson(Map<String, dynamic> json) {
    return Noun(
      la: json["la"],
      en: json["en"],
      type: nounTypeFromString(json["type"]),
      num: json["num"],
      sex: sexTypeFromString(json["sex"]),
      idx: json["idx"],
      meta: json.containsKey("meta")
          ? Meta.fromJson(json["meta"])
          : Meta(score: [], tags: []),
    );
  }

// 単語の活用
  String conjugate(NounConjugateType w, Numbers m) {
    switch (this.num) {
      case '1': // a
        String stem = la.substring(0, la.length - 1);
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
        if (la.endsWith("er")) {
          if (w == NounConjugateType.nom && m == Numbers.single) {
            return la;
          }
          List<String> liberList = [
            "liber",
            "asper",
            "miser",
            "prosper",
            "tener"
          ];
          if (liberList.contains(la)) {
            stem = la;
          } else {
            stem = "${la.substring(0, la.length - 2)}r";
          }
        } else {
          stem = la.substring(0, la.length - 2);
        }
        if (sex == SexType.m) {
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
          return la;
        }
        // 男性か女性ならhomō, leō, lex, canis
        if (sex == SexType.f || sex == SexType.m) {
          String stem = "";
          if (la.endsWith("is")) {
            stem = la.substring(0, la.length - 2);
            // 末尾がxならlex
          } else if (la[la.length - 1] == "x") {
            stem = "${la.substring(0, la.length - 1)}g";
            // 2番目が母音ならleo
          } else if ("aiueoāīūēō".contains(la[la.length - 2])) {
            stem = "${la}n";
            // 子音ならhomo
          } else {
            stem = "${la.substring(0, la.length - 1)}in";
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
            return la;
          }
          String stem = "";
          switch (la.substring(la.length - 2, la.length)) {
            case "ut":
              stem = "${la.substring(0, la.length - 2)}it";
              break;
            case "us":
              stem = "${la.substring(0, la.length - 2)}or";
              break;
            case "en":
              stem = "${la.substring(0, la.length - 2)}in";
              break;
            default:
              stem = la;
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
          return la;
        }
        // is, es, s, -(er), -(al, ar), e
        if (la.endsWith("is")) {
          String stem = la.substring(0, la.length - 2);
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
        } else if (la.endsWith("es") || la.endsWith("ēs")) {
          String stem = la.substring(0, la.length - 2);
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
        } else if (la.endsWith("s")) {
          String stem = la.substring(0, la.length - 1);
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
        } else if (la.endsWith("er")) {
          String stem = "${la.substring(0, la.length - 2)}r";
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
            .contains(la.substring(la.length - 2, la.length))) {
          if (m == Numbers.single && w == NounConjugateType.acc) {
            return la;
          }
          String stem = la.endsWith("al")
              ? "${la.substring(0, la.length - 2)}āl"
              : la.endsWith("ar")
                  ? "${la.substring(0, la.length - 2)}ār"
                  : la;
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
          String stem = la.substring(0, la.length - 2);
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
        return "<Unknown noun>: ${la}${num}";
    }
  }
}

// --

Future<void> loadNounData() async {
  final dbclient = await db.database;

  // 全取得する SQL を実行
  List<Map<String, dynamic>> results = await dbclient.rawQuery('''
  select
    $nounTable.id, $nounTable.la, $nounTable.en, $nounTable.nounType,
    $nounTable.num, $nounTable.sex, $metaTable.score, $metaTable.tags
  from $nounTable
    join $metaTable on $metaTable.rowId=$nounTable.id
    where $metaTable.kind = 'noun';
  ''');

  // 取得した結果から WTR モデルのリストとして作成
  nounData = results
      .map((row) => Noun(
            idx: row["id"],
            la: row["la"],
            en: row["en"],
            type: NounType.values[row["nounType"]],
            num: row["num"],
            sex: SexType.values[row["sex"]],
            meta: Meta(
              score: row["score"].split(";").map((s) => int.parse(s)).toList(),
              tags: row["tags"]
                  .split(";")
                  .map((s) => tagData[int.parse(s)])
                  .toList(),
            ),
          ))
      .toList();
}

NounType nounTypeFromString(String nounType) {
  Map<String, NounType> wordMap = {
    "noun": NounType.noun,
    "verb": NounType.verb,
    "adjective": NounType.adjective
  };
  NounType? result = wordMap[NounType];
  if (result != null) {
    return result;
  } else {
    return NounType.noun;
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

List<Noun> getRandomNouns({int num = 7}) {
  List<Noun> nouns = List.from(nounData);
  nouns.shuffle();
  if (nouns.length < num) {
    return nouns;
  } else {
    return nouns.sublist(0, num).toList();
  }
}

// ランダム
NounConjugateType getRandomNounConjugateType() {
  List<NounConjugateType> list = NounConjugateType.values;
  int randomIndex = random.nextInt(list.length);
  return list[randomIndex];
}

// ランダムな数/格の単語をいくつか返す
List<String> getRandomConjugated(Noun noun, {int size = 5}) {
  List<String> allCandidate = [];
  for (var m in Numbers.values) {
    for (var c in NounConjugateType.values) {
      allCandidate.add(noun.conjugate(c, m));
    }
  }

  allCandidate = allCandidate.toSet().toList();
  allCandidate.shuffle();

  return allCandidate.sublist(0, size);
}

Noun getNounById(int id) {
  for (var n in nounData) {
    if (n.idx == id) {
      return n;
    }
  }

  return Noun(
      la: "",
      en: "",
      type: NounType.noun,
      num: "1",
      sex: SexType.f,
      idx: 1,
      meta: Meta(score: [], tags: []));
}
