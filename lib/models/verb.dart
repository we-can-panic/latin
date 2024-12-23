import "dart:convert";
import "dart:io";

import "package:flutter/services.dart";

import "../repositories/database/database.dart";
import "enumeration.dart";

Map<String, dynamic> verbConjugateRules = {};
Map<String, dynamic> verbIrregularsConjugateRules = {};

// verbクラス
class Verb {
  int id;
  String la;
  String en;
  VerbConjugateType conjugateType;

  Verb({
    required this.id,
    required this.la,
    required this.en,
    required this.conjugateType,
  });

  // 連想配列からロード
  factory Verb.fromJson(Map<String, dynamic> json) {
    return Verb(
      id: json["id"],
      la: json["la"],
      en: json["en"],
      conjugateType: getVerbConjugateTypeFromInt(json["conjugateType"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "la": la,
      "en": en,
      "conjugateType": conjugateType.index,
    };
  }

  String conjugate(Mode m, Form f, Tense t, Person p, Numbers num) {
    // 不規則動詞の活用形を取得
    if (isIrregularConjugation(la)) {
      try {
        String word = verbIrregularsConjugateRules[la]
                            ?[m.toString().split('.').last]
                        ?[f.toString().split('.').last]
                    ?[t.toString().split('.').last]
                ?[num.toString().split('.').last]?[p.index] ??
            '???';
        return word;
      } catch (e) {
        return la;
      }
    } else {
      // 基本語幹を分離 (不定形の末尾の "-re" を除去)
      String stem = la.substring(0, la.length - 2);

      // 活用形を取得
      try {
        // ConjugateType.vt1 -> vt1
        String key = conjugateType.toString().split('.').last;
        String ending = verbConjugateRules[key]?[m.toString().split('.').last]
                        ?[f.toString().split('.').last]
                    ?[t.toString().split('.').last]
                ?[num.toString().split('.').last]?[p.index] ??
            '???';
        return stem + ending;
      } catch (e) {
        return la;
      }
    }
  }

  bool isIrregularConjugation(String la) {
    return verbIrregularsConjugateRules.containsKey(la);
  }
}

Verb defaultVerb = Verb(
  id: -1,
  la: "",
  en: "",
  conjugateType: VerbConjugateType.vt1,
);

// --

Future<List<Verb>> loadVerbData() async {
  verbConjugateRules =
      jsonDecode(await rootBundle.loadString('assets/verbConjugateRules.json'));
  verbIrregularsConjugateRules = jsonDecode(
      await rootBundle.loadString('assets/verbIrregularsConjugateRules.json'));

  final dbclient = await db.database;

  // 全取得する SQL を実行
  List<Map<String, dynamic>> results = await dbclient.rawQuery('''
  select * from $verbTable
  ''');

  return results.map((result) => Verb.fromJson(result)).toList();
}

// String getRandomConjugatedVerb(Verb verb) {
//   Mode m = Mode.values[random.nextInt(Mode.values.length)];
//   Form f = Form.values[random.nextInt(Form.values.length)];
//   Tense t = Tense.values[random.nextInt(Tense.values.length)];
//   Person p = Person.values[random.nextInt(Person.values.length)];
//   Numbers num = Numbers.values[random.nextInt(Numbers.values.length)];
//   return verb.conjugate(m, f, t, p, num);
// }
