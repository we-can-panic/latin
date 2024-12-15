import "../repositories/database/database.dart";
import 'enumeration.dart';

class Noun {
  int id;
  String la;
  String en;
  NounType nounType;
  NounConjugateType conjugateType;
  SexType sex;

  Noun({
    required this.id,
    required this.la,
    required this.en,
    required this.nounType,
    required this.conjugateType,
    required this.sex,
  });

  // 連想配列からロード
  factory Noun.fromJson(Map<String, dynamic> json) {
    return Noun(
      id: json["id"],
      la: json["la"],
      en: json["en"],
      nounType: getNounTypeFromInt(json["nounType"]),
      conjugateType: getNounConjugateTypeFromInt(json["conjugateType"]),
      sex: getSexTypeFromInt(json["sex"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "la": la,
      "en": en,
      "nounType": nounType.index,
      "conjugateType": conjugateType.index,
      "sex": sex.index,
    };
  }

  // 単語の活用
  String conjugate(NounCase w, Numbers m) {
    if (la.isEmpty) return "";
    switch (conjugateType) {
      case NounConjugateType.nt1: // a
        String stem = la.substring(0, la.length - 1);
        Map<Numbers, Map<NounCase, String>> map = {
          Numbers.single: {
            NounCase.nom: "a",
            NounCase.voc: "a",
            NounCase.gen: "ae",
            NounCase.dat: "ae",
            NounCase.acc: "am",
            NounCase.abl: "ā",
          },
          Numbers.multi: {
            NounCase.nom: "ae",
            NounCase.voc: "ae",
            NounCase.gen: "ārum",
            NounCase.dat: "īs",
            NounCase.acc: "ās",
            NounCase.abl: "īs",
          }
        };
        return stem + map[m]![w]!;
      case NounConjugateType.nt2: // us, um, er
        String stem = "";
        if (la.endsWith("er")) {
          if (w == NounCase.nom && m == Numbers.single) {
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
          Map<Numbers, Map<NounCase, String>> map = {
            Numbers.single: {
              NounCase.nom: "us",
              NounCase.voc: "e",
              NounCase.gen: "ī",
              NounCase.dat: "ō",
              NounCase.acc: "um",
              NounCase.abl: "ō",
            },
            Numbers.multi: {
              NounCase.nom: "ī",
              NounCase.voc: "ī",
              NounCase.gen: "ōrum",
              NounCase.dat: "īs",
              NounCase.acc: "ōs",
              NounCase.abl: "īs",
            }
          };
          return stem + map[m]![w]!;
        } else {
          Map<Numbers, Map<NounCase, String>> map = {
            Numbers.single: {
              NounCase.nom: "um",
              NounCase.voc: "um",
              NounCase.gen: "ī",
              NounCase.dat: "ō",
              NounCase.acc: "um",
              NounCase.abl: "ō",
            },
            Numbers.multi: {
              NounCase.nom: "a",
              NounCase.voc: "a",
              NounCase.gen: "ārum",
              NounCase.dat: "īs",
              NounCase.acc: "a",
              NounCase.abl: "īs",
            }
          };
          return stem + map[m]![w]!;
        }
      case NounConjugateType.nt3: // homō. leō, lex, genus, caput, nomen, canis
        if (w == NounCase.nom && m == Numbers.single) {
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
          Map<Numbers, Map<NounCase, String>> map = {
            Numbers.single: {
              NounCase.nom: "",
              NounCase.voc: "",
              NounCase.gen: "is",
              NounCase.dat: "ī",
              NounCase.acc: "em",
              NounCase.abl: "e",
            },
            Numbers.multi: {
              NounCase.nom: "ēs",
              NounCase.voc: "ēs",
              NounCase.gen: "um",
              NounCase.dat: "ibus",
              NounCase.acc: "ēs",
              NounCase.abl: "ibus",
            }
          };
          return stem + map[m]![w]!;
        } else {
          // genus, caput, nomen
          if ((m == Numbers.single) &&
              (w == NounCase.nom || w == NounCase.acc)) {
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
          Map<Numbers, Map<NounCase, String>> map = {
            Numbers.single: {
              NounCase.nom: "",
              NounCase.voc: "",
              NounCase.gen: "is",
              NounCase.dat: "ī",
              NounCase.acc: "",
              NounCase.abl: "e",
            },
            Numbers.multi: {
              NounCase.nom: "a",
              NounCase.voc: "a",
              NounCase.gen: "um",
              NounCase.dat: "ibus",
              NounCase.acc: "a",
              NounCase.abl: "ibus",
            }
          };
          return stem + map[m]![w]!;
        }
      case NounConjugateType.nt3i: // ignis, animal, feles, calcar
        if (m == Numbers.single && w == NounCase.nom) {
          return la;
        }
        // is, es, s, -(er), -(al, ar), e
        if (la.endsWith("is")) {
          String stem = la.substring(0, la.length - 2);
          Map<Numbers, Map<NounCase, String>> map = {
            Numbers.single: {
              NounCase.nom: "is",
              NounCase.voc: "is",
              NounCase.gen: "is",
              NounCase.dat: "ī",
              NounCase.acc: "im",
              NounCase.abl: "ī",
            },
            Numbers.multi: {
              NounCase.nom: "ēs",
              NounCase.voc: "ēs",
              NounCase.gen: "ium",
              NounCase.dat: "ibus",
              NounCase.acc: "īs",
              NounCase.abl: "ibus",
            }
          };
          return stem + map[m]![w]!;
        } else if (la.endsWith("es") || la.endsWith("ēs")) {
          String stem = la.substring(0, la.length - 2);
          Map<Numbers, Map<NounCase, String>> map = {
            Numbers.single: {
              NounCase.nom: "ēs",
              NounCase.voc: "ēs",
              NounCase.gen: "is",
              NounCase.dat: "ī",
              NounCase.acc: "em",
              NounCase.abl: "e",
            },
            Numbers.multi: {
              NounCase.nom: "ēs",
              NounCase.voc: "ēs",
              NounCase.gen: "ium",
              NounCase.dat: "ibus",
              NounCase.acc: "is",
              NounCase.abl: "ibus",
            }
          };
          return stem + map[m]![w]!;
        } else if (la.endsWith("s")) {
          String stem = la.substring(0, la.length - 1);
          Map<Numbers, Map<NounCase, String>> map = {
            Numbers.single: {
              NounCase.nom: "s",
              NounCase.voc: "s",
              NounCase.gen: "is",
              NounCase.dat: "ī",
              NounCase.acc: "em",
              NounCase.abl: "e",
            },
            Numbers.multi: {
              NounCase.nom: "ēs",
              NounCase.voc: "ēs",
              NounCase.gen: "ium",
              NounCase.dat: "ibus",
              NounCase.acc: "is",
              NounCase.abl: "ibus",
            }
          };
          return stem + map[m]![w]!;
        } else if (la.endsWith("er")) {
          String stem = "${la.substring(0, la.length - 2)}r";
          Map<Numbers, Map<NounCase, String>> map = {
            Numbers.single: {
              NounCase.nom: "er",
              NounCase.voc: "er",
              NounCase.gen: "is",
              NounCase.dat: "ī",
              NounCase.acc: "em",
              NounCase.abl: "e",
            },
            Numbers.multi: {
              NounCase.nom: "ēs",
              NounCase.voc: "ēs",
              NounCase.gen: "ium",
              NounCase.dat: "ibus",
              NounCase.acc: "īs",
              NounCase.abl: "ibus",
            }
          };
          return stem + map[m]![w]!;
        } else if (["al", "āl", "ar", "ār"]
            .contains(la.substring(la.length - 2, la.length))) {
          if (m == Numbers.single && w == NounCase.acc) {
            return la;
          }
          String stem = la.endsWith("al")
              ? "${la.substring(0, la.length - 2)}āl"
              : la.endsWith("ar")
                  ? "${la.substring(0, la.length - 2)}ār"
                  : la;
          Map<Numbers, Map<NounCase, String>> map = {
            Numbers.single: {
              NounCase.nom: "",
              NounCase.voc: "",
              NounCase.gen: "is",
              NounCase.dat: "ī",
              NounCase.acc: "",
              NounCase.abl: "ī",
            },
            Numbers.multi: {
              NounCase.nom: "ia",
              NounCase.voc: "ia",
              NounCase.gen: "ium",
              NounCase.dat: "ibus",
              NounCase.acc: "ia",
              NounCase.abl: "ibus",
            }
          };
          return stem + map[m]![w]!;
        } else {
          // mare
          String stem = la.substring(0, la.length - 2);
          Map<Numbers, Map<NounCase, String>> map = {
            Numbers.single: {
              NounCase.nom: "e",
              NounCase.voc: "e",
              NounCase.gen: "is",
              NounCase.dat: "ī",
              NounCase.acc: "e",
              NounCase.abl: "ī",
            },
            Numbers.multi: {
              NounCase.nom: "ia",
              NounCase.voc: "ia",
              NounCase.gen: "ium",
              NounCase.dat: "ibus",
              NounCase.acc: "ia",
              NounCase.abl: "ibus",
            }
          };
          return stem + map[m]![w]!;
        }
    }
  }
}

Noun defaultNoun = Noun(
  id: -1,
  la: "",
  en: "",
  nounType: NounType.noun,
  conjugateType: NounConjugateType.nt1,
  sex: SexType.f,
);

// // --

Future<List<Noun>> loadNounData() async {
  final dbclient = await db.database;

  // 全取得する SQL を実行
  List<Map<String, dynamic>> results = await dbclient.rawQuery('''
  select
    id, la, en, nounType, conjugateType, sex
  from $nounTable
  ''');

  return results.map((result) => Noun.fromJson(result)).toList();
}
