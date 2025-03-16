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
        String? word = verbIrregularsConjugateRules[la]
                    ?[m.toString().split('.').last]
                ?[f.toString().split('.').last]?[t.toString().split('.').last]
            ?[num.toString().split('.').last]?[p.index];
        if (word != null) {
          return word;
        }
      } catch (e) {
        // エラーが発生した場合は規則変化として処理
      }
    }

    // 基本語幹を分離（不定形から）
    String stem = "";
    switch (conjugateType) {
      case VerbConjugateType.vt1:
        // amare -> am
        stem = la.substring(0, la.length - 3);
        break;
      case VerbConjugateType.vt2:
        // videre -> vid
        stem = la.substring(0, la.length - 3);
        break;
      case VerbConjugateType.vt3:
        // ducere -> duc
        stem = la.substring(0, la.length - 3);
        break;
      case VerbConjugateType.vt3i:
        // capere -> cap
        stem = la.substring(0, la.length - 3);
        break;
      case VerbConjugateType.vt4:
        // audire -> aud
        stem = la.substring(0, la.length - 3);
        break;
    }

    // 活用形を取得
    try {
      String key = conjugateType.toString().split('.').last;
      print('Debug - key: $key'); // デバッグ出力
      var modeKey = m.toString().split('.').last;
      print('Debug - modeKey: $modeKey'); // デバッグ出力
      var formKey = f.toString().split('.').last;
      print('Debug - formKey: $formKey'); // デバッグ出力
      var tenseKey = t.toString().split('.').last;
      print('Debug - tenseKey: $tenseKey'); // デバッグ出力
      var numKey = num.toString().split('.').last;
      print('Debug - numKey: $numKey'); // デバッグ出力

      var conjugateRule = verbConjugateRules[key];
      print('Debug - conjugateRule: $conjugateRule'); // デバッグ出力

      var endings =
          verbConjugateRules[key]?[modeKey]?[formKey]?[tenseKey]?[numKey];
      print('Debug - endings: $endings'); // デバッグ出力
      print('Debug - endings type: ${endings.runtimeType}'); // デバッグ出力

      if (endings is List && p.index < endings.length) {
        String ending = endings[p.index];
        print('Debug - selected ending: $ending'); // デバッグ出力
        print('Debug - stem: $stem'); // デバッグ出力
        print('Debug - final form: ${stem + ending}'); // デバッグ出力
        return stem + ending;
      }
    } catch (e) {
      print('Debug - error: $e'); // デバッグ出力
      // エラーが発生した場合は原形を返す
    }
    print('Debug - fallback to infinitive: $la'); // デバッグ出力
    return la;
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
