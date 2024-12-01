import 'dart:core';

import 'package:latin/models/noun.dart';
import 'package:latin/models/nounComponent.dart';
import 'package:latin/repositories/database/database.dart';

import 'nounComponent.dart';
import 'verbComponent.dart';

// --

class Sentence {
  int id;
  String la;
  String en;
  List<NounComponent> nounComponents;
  List<VerbComponent> verbComponents;

  Sentence({
    required this.id,
    required this.la,
    required this.en,
    required this.nounComponents,
    required this.verbComponents,
  });

  // 連想配列からロード
  factory Sentence.fromJson(
    Map<String, dynamic> json,
    List<NounComponent> nounComponents,
    List<VerbComponent> verbComponents,
  ) {
    return Sentence(
      id: json["id"],
      la: json["la"]!,
      en: json["en"]!,
      nounComponents: [
        for (var id in json["nounComponents"]!.split(";"))
          getNounComponentById(int.parse(id), nounComponents)
      ],
      verbComponents: [
        for (var id in json["verbComponents"]!.split(";"))
          getVerbComponentById(int.parse(id), verbComponents)
      ],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "la": la,
      "en": en,
      "nounComponents": nounComponents.map((n) => n.id).join(","),
      "verbComponents": verbComponents.map((v) => v.id).join(","),
    };
  }
}

NounComponent getNounComponentById(int id, List<NounComponent> datas) {
  for (var n in datas) {
    if (n.id == id) {
      return n;
    }
  }
  return defaultNounComponent;
}

VerbComponent getVerbComponentById(int id, List<VerbComponent> datas) {
  for (var n in datas) {
    if (n.id == id) {
      return n;
    }
  }
  return defaultVerbComponent;
}

Sentence defaultSentence = Sentence(
  id: -1,
  la: "",
  en: "",
  nounComponents: List.empty(),
  verbComponents: List.empty(),
);

Future<List<Sentence>> loadSentenceData(List<NounComponent> nounComponents,
    List<VerbComponent> verbComponents) async {
  final dbclient = await db.database;

  // 全取得する SQL を実行
  List<Map<String, dynamic>> results = await dbclient.rawQuery('''
  select
    id, la, en, nounComponents, verbComponents
  from $sentenceTable
  ''');

  return results
      .map((result) => Sentence.fromJson(
            result,
            nounComponents,
            verbComponents,
          ))
      .toList();
}
