import 'word.dart';

// verbクラス
class Verb extends Word {
  String la;
  String en;
  String num;
  int idx;
  // VerbはWordと差分なし
  Verb(
      {required this.la,
      required this.en,
      required this.num,
      required this.idx})
      : super(la: la, en: en, num: num, idx: idx);

  // 連想配列からロード
  factory Verb.fromJson(Map<String, dynamic> json) {
    // List<Person> people = jsonData.map((json) => Person.fromJson(json)).toList();
    return Verb(
      la: json["la"],
      en: json["en"],
      num: json["num"],
      idx: json["idx"],
    );
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
