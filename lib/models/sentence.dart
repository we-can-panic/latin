import "../database/database.dart";
import 'noun.dart';
import 'verb.dart';
import 'meta.dart';
import 'nounComponent.dart';
import 'verbComponent.dart';

// 全てのSentenceデータ
List<Sentence> sentenceData = [];

// --

class Sentence {
  String la;
  String en;
  List<NounComponent> nounComponents;
  List<VerbComponent> verbComponents;
  int idx;
  Meta meta;

  Sentence(
      {required this.la,
      required this.en,
      required this.nounComponents,
      required this.verbComponents,
      required this.idx,
      required this.meta});

  // 連想配列からロード
  factory Sentence.fromJson(Map<String, dynamic> json) {
    List<NounComponent> nounComponents = json["nounComponents"]
        .map((row) => NounComponent(
            noun: row["noun"],
            conjugateType: row["conjugateType"],
            num: row["num"]))
        .toList();
    List<VerbComponent> verbComponents = json["verbComponents"]
        .map((row) => VerbComponent(
            verb: row["verb"],
            mode: row["mode"],
            form: row["form"],
            tense: row["tense"],
            person: row["person"],
            num: row["num"]))
        .toList();
    return Sentence(
      la: json["la"],
      en: json["en"],
      nounComponents: nounComponents,
      verbComponents: verbComponents,
      idx: json["idx"],
      meta: json.containsKey("meta")
          ? Meta.fromJson(json["meta"])
          : Meta(score: [], tags: []),
    );
  }
}

Future<void> loadSentenceData() async {
  final dbclient = await db.database;

  // 全取得する SQL を実行
  List<Map<String, dynamic>> results = await dbclient.rawQuery('''
  select
    $sentenceTable.id, $sentenceTable.la, $sentenceTable.en,
    $sentenceTable.nounComponents, $sentenceTable.verbComponents,
    $metaTable.score, $metaTable.tags
  from $sentenceTable
    join $metaTable on $metaTable.rowId=$sentenceTable.id
    where $metaTable.kind = 'sentence';
  ''');

  List<Map<String, dynamic>> nounComponentResults = await dbclient.rawQuery('''
    select id, nounId, conjugate, Number from $nounComponentTable
  ''');
  Map<int, NounComponent> nounComponentmap = {
    for (var row in nounComponentResults)
      row["id"]: NounComponent(
        noun: getNounById(row["nounId"]),
        conjugateType: NounConjugateType.values[row["conjugateType"]],
        num: row["num"],
      )
  };

  List<Map<String, dynamic>> verbComponentResults = await dbclient.rawQuery('''
    select id, verbId, mode, form, tense, person, number from $verbComponentTable
  ''');
  Map<int, VerbComponent> verbComponentmap = {
    for (var row in verbComponentResults)
      row["id"]: VerbComponent(
        verb: getVerbById(row["verbId"]),
        mode: Mode.values[row["mode"]],
        form: Form.values[row["form"]],
        tense: Tense.values[row["tense"]],
        person: Person.values[row["person"]],
        num: row["number"],
      )
  };

  // 取得した結果から WTR モデルのリストとして作成
  sentenceData = results.map((row) {
    return Sentence(
      idx: row["idx"],
      la: row["la"],
      en: row["en"],
      nounComponents: row["nounComponents"]
          .split(";")
          .map((s) => nounComponentmap[int.parse(s)])
          .toList(),
      verbComponents: row["verbComponents"]
          .split(";")
          .map((s) => verbComponentmap[int.parse(s)])
          .toList(),
      meta: Meta(
        score: row["score"].split(";").map((s) => int.parse(s)).toList(),
        tags: row["tags"].split(";").map((s) => tagData[int.parse(s)]).toList(),
      ),
    );
  }).toList();
}
