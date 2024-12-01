import 'package:latin/repositories/database/database.dart';

import "verb.dart";
import 'enumeration.dart';

// 活用含めたNoun
class VerbComponent {
  int id;
  Verb verb;
  Mode mode;
  Form form;
  Tense tense;
  Person person;
  Numbers num;

  String get la => verb.conjugate(mode, form, tense, person, num);
  String get en => verb.en;

  VerbComponent({
    required this.id,
    required this.verb,
    required this.mode,
    required this.form,
    required this.tense,
    required this.person,
    required this.num,
  });

  // 連想配列からロード
  factory VerbComponent.fromJson(
      Map<String, dynamic> json, List<Verb> verbData) {
    return VerbComponent(
      id: json["id"],
      verb: getVerbById(json["verbId"], verbData),
      mode: getModeFromInt(json["mode"]),
      form: getFormFromInt(json["form"]),
      tense: getTenseFromInt(json["tense"]),
      person: getPersonFromInt(json["person"]),
      num: getNumbersFromInt(json["num"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "verbId": verb.id,
      "mode ": mode.index,
      "form": form.index,
      "tense": tense.index,
      "person": person.index,
      "num": num.index,
    };
  }
}

// --

Future<List<VerbComponent>> loadVerbComponentData(List<Verb> verbData) async {
  final dbclient = await db.database;

  // 全取得する SQL を実行
  List<Map<String, dynamic>> results = await dbclient.rawQuery('''
  select
    *
  from $verbComponentTable
  ''');

  return results
      .map((result) => VerbComponent.fromJson(result, verbData))
      .toList();
}

VerbComponent defaultVerbComponent = VerbComponent(
  id: -1,
  verb: defaultVerb,
  mode: Mode.indicative,
  form: Form.active,
  tense: Tense.present,
  person: Person.first,
  num: Numbers.single,
);

Verb getVerbById(int id, List<Verb> verbData) {
  for (var noun in verbData) {
    if (noun.id == id) {
      return noun;
    }
  }
  return defaultVerb;
}


// List<VerbComponent> getRandomVerbComponents({int num = 4}) {
//   return getRandomVerbs(num: 4)
//       .map((v) => VerbComponent(
//             verb: v,
//             mode: getRandomMode(),
//             form: getRandomForm(),
//             tense: getRandomTense(),
//             person: getRandomPerson(),
//             num: getRandomNumbers(),
//           ))
//       .toList();
// }
