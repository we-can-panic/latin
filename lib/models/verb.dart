import "../repositories/database/database.dart";
import "enumeration.dart";

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
    return la;
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
