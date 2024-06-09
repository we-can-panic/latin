import "../database/database.dart";
import 'word.dart';
import "meta.dart";

List<Verb> verbData = []; // 全てのVerbデータ

// --

// verbクラス
class Verb extends Word {
  // VerbはWordと差分なし
  Verb(
      {required super.la,
      required super.en,
      required super.num,
      required super.idx,
      required super.meta});

  // 連想配列からロード
  factory Verb.fromJson(Map<String, dynamic> json) {
    return Verb(
      la: json["la"],
      en: json["en"],
      num: json["num"],
      idx: json["idx"],
      meta: json.containsKey("meta")
          ? Meta.fromJson(json["meta"])
          : Meta(score: [], tags: []),
    );
  }

  String conjugate(Mode m, Form f, Tense t, Person p, Numbers num) {
    return la;
  }
}

// 法: 直接、命令、接続
enum Mode { indicative, inperative, subjunctive }

// 態: 能動、受動
enum Form { active, passive }

// 時制: 現在、過去、現在完了、過去完了
enum Tense { present, past, presentPerfect, pastPerfect }

// 人称: 1人、2人、3人
enum Person { first, second, third }

// --

Future<void> loadVerbData() async {
  final dbclient = await db.database;

  // 全取得する SQL を実行
  List<Map<String, dynamic>> results = await dbclient.rawQuery('''
  select
    $verbTable.id, $verbTable.la, $verbTable.en, $verbTable.num,
    $metaTable.score, $metaTable.tags
  from $verbTable
    join $metaTable on $metaTable.rowId=$verbTable.id
    where $metaTable.kind = 'verb';
  ''');

  int stringToIntWithDefault(String str, {int defaultValue = 0}) {
    try {
      return int.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  String getTagDataWithDefault(int id) {
    final result = tagData[id];
    if (result == null) {
      return "";
    } else {
      return result;
    }
  }

  // 取得した結果から WTR モデルのリストとして作成
  verbData = results
      .map((row) => Verb(
            idx: row["id"],
            la: row["la"],
            en: row["en"],
            num: row["num"],
            meta: Meta(
              score: List<String>.from(row["score"].split(";"))
                  .map((s) => stringToIntWithDefault(s))
                  .toList(),
              tags: List<String>.from(row["tags"].split(";"))
                  // .map((s) => tagData[stringToIntWithDefault(s)]!)
                  .map((s) => getTagDataWithDefault(stringToIntWithDefault(s)))
                  .toList(),
            ),
          ))
      .toList();
}

String modeToString(Mode m) {
  switch (m) {
    case Mode.indicative:
      return "直接";
    case Mode.inperative:
      return "命令";
    case Mode.subjunctive:
      return "接続";
  }
}

// 態: 能動、受動
String formToString(Form m) {
  switch (m) {
    case Form.active:
      return "能動";
    case Form.passive:
      return "受動";
  }
}

// 時制: 現在、過去、現在完了、過去完了
String tenseToString(Tense m) {
  switch (m) {
    case Tense.present:
      return "現在";
    case Tense.past:
      return "過去";
    case Tense.presentPerfect:
      return "現在完了";
    case Tense.pastPerfect:
      return "過去完了";
  }
}

// 人称: 1人、2人、3人
String personToString(Person m) {
  switch (m) {
    case Person.first:
      return "一人称";
    case Person.second:
      return "二人称";
    case Person.third:
      return "三人称";
  }
}

List<Verb> getRandomVerbs({int num = 7}) {
  List<Verb> verbs = List.from(verbData);
  verbs.shuffle();
  if (verbs.length < num) {
    return verbs;
  } else {
    return verbs.sublist(0, num).toList();
  }
}

String getRandomConjugatedVerb(Verb verb) {
  Mode m = Mode.values[random.nextInt(Mode.values.length)];
  Form f = Form.values[random.nextInt(Form.values.length)];
  Tense t = Tense.values[random.nextInt(Tense.values.length)];
  Person p = Person.values[random.nextInt(Person.values.length)];
  Numbers num = Numbers.values[random.nextInt(Numbers.values.length)];
  return verb.conjugate(m, f, t, p, num);
}

Verb getVerbById(int id) {
  for (var n in verbData) {
    if (n.idx == id) {
      return n;
    }
  }

  return Verb(
      la: "", en: "", num: "1", idx: 1, meta: Meta(score: [], tags: []));
}

Mode getRandomMode() {
  return Mode.values[random.nextInt(Mode.values.length)];
}

Form getRandomForm() {
  return Form.values[random.nextInt(Form.values.length)];
}

Tense getRandomTense() {
  return Tense.values[random.nextInt(Tense.values.length)];
}

Person getRandomPerson() {
  return Person.values[random.nextInt(Person.values.length)];
}
