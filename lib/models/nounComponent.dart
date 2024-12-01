import 'package:latin/apps/noun.dart';
import 'package:latin/repositories/database/database.dart';

import "noun.dart";
import 'enumeration.dart';

// 活用含めたNoun
class NounComponent {
  int id;
  Noun noun;
  NounCase nounCase;
  Numbers num;

  String get la => noun.conjugate(nounCase, num);
  String get en => noun.en;

  NounComponent({
    required this.id,
    required this.noun,
    required this.nounCase,
    required this.num,
  });

  // 連想配列からロード
  factory NounComponent.fromJson(
      Map<String, dynamic> json, List<Noun> nounData) {
    return NounComponent(
      id: json["id"],
      noun: getNounById(json["nounId"], nounData),
      nounCase: getNounCaseFromInt(json["nounCase"]),
      num: getNumbersFromInt(json["num"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nounId": noun.id,
      "nounCase": nounCase.index,
      "num": num.index,
    };
  }
}

NounComponent defaultNounComponent = NounComponent(
  id: -1,
  noun: defaultNoun,
  nounCase: NounCase.nom,
  num: Numbers.single,
);

// --

Future<List<NounComponent>> loadNounComponentData(List<Noun> nounData) async {
  final dbclient = await db.database;

  // 全取得する SQL を実行
  List<Map<String, dynamic>> results = await dbclient.rawQuery('''
  select
    *
  from $nounComponentTable
  ''');

  return results
      .map((result) => NounComponent.fromJson(result, nounData))
      .toList();
}

Noun getNounById(int id, List<Noun> nounData) {
  for (var noun in nounData) {
    if (noun.id == id) {
      return noun;
    }
  }
  return defaultNoun;
}
