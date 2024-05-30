import 'word.dart';

// wordクラス
class Noun extends Word {
  String la;
  String en;
  NounType type;
  String num;
  SexType sex;
  int idx;

  Noun(
      {required this.la,
      required this.en,
      required this.type,
      required this.num,
      required this.sex,
      required this.idx})
      : super(la: la, en: en, num: num, idx: idx);

  // 連想配列からロード
  factory Noun.fromJson(Map<String, dynamic> json) {
    // List<Person> people = jsonData.map((json) => Person.fromJson(json)).toList();
    return Noun(
      la: json["la"],
      en: json["en"],
      type: nounTypeFromString(json["type"]),
      num: json["num"],
      sex: sexTypeFromString(json["sex"]),
      idx: json["idx"],
    );
  }
}

// 単語タイプ
enum NounType { noun, verb, adjective }

// 単語活用タイプ
enum NounConjugateType { nom, gen, dat, acc, abl }

// 性
enum SexType { f, m, n }

NounType nounTypeFromString(String nounType) {
  Map<String, NounType> wordMap = {
    "noun": NounType.noun,
    "verb": NounType.verb,
    "adjective": NounType.adjective
  };
  NounType? result = wordMap[NounType];
  if (result != null) {
    return result;
  } else {
    return NounType.noun;
  }
}

SexType sexTypeFromString(String sexType) {
  switch (sexType) {
    case "m":
      return SexType.m;
    case "f":
      return SexType.f;
    case "n":
      return SexType.n;
    default:
      return SexType.m;
  }
}

String sexTypeToString(SexType sexType) {
  switch (sexType) {
    case SexType.m:
      return "男性";
    case SexType.f:
      return "女性";
    case SexType.n:
      return "中性";
  }
}
