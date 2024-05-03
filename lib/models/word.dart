List<Word> wordData = [];

class Word {
  String la;
  String en;
  WordType type;
  String num;
  SexType sex;
  int idx;

  Word(
      {required this.la,
      required this.en,
      required this.type,
      required this.num,
      required this.sex,
      required this.idx});

  // 連想配列からロード
  factory Word.fromJson(Map<String, dynamic> json) {
    // List<Person> people = jsonData.map((json) => Person.fromJson(json)).toList();
    return Word(
      la: json["la"],
      en: json["en"],
      type: wordTypeFromString(json["type"]),
      num: json["num"],
      sex: sexTypeFromString(json["sex"]),
      idx: json["idx"],
    );
  }
}

// 単語タイプ
enum WordType { noun, verb, adjective }

// 単語活用タイプ
enum NounConjugateType { nom, gen, dat, acc, abl }

// 単数か複数
enum MultiType { single, multi }

// 性
enum SexType { f, m, n }

class WordMeta {
  int wordIdx;
  List<int> score;
  List<String> tags;

  WordMeta({required this.wordIdx, required this.tags, required this.score});

  // 連想配列からロード
  factory WordMeta.fromJson(Map<String, dynamic> json,
      {required Map<int, String> tag}) {
    return WordMeta(
      wordIdx: json["wordIdx"],
      score: json["score"].cast<int>(),
      tags: json["tags"]
          .cast<int>()
          .map((tagId) => tag[tagId])
          .cast<String>()
          .toList(),
    );
  }
}

WordType wordTypeFromString(String wordType) {
  Map<String, WordType> wordMap = {
    "noun": WordType.noun,
    "verb": WordType.verb,
    "adjective": WordType.adjective
  };
  WordType? result = wordMap[wordType];
  if (result != null) {
    return result;
  } else {
    return WordType.noun;
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

String multiTypeToString(MultiType multiType) {
  switch (multiType) {
    case MultiType.single:
      return "単数";
    case MultiType.multi:
      return "複数";
  }
}

Word getWordByIdx(int idx) {
  for (var w in wordData) {
    if (idx == w.idx) {
      return w;
    }
  }
  return Word(
      la: "", en: "", type: WordType.noun, num: "1", sex: SexType.f, idx: -1);
}
