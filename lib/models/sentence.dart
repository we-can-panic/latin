import 'word.dart';

class Sentence {
  String la;
  String en;
  List<Word> wordComponents;
  int idx;

  Sentence(
      {required this.la,
      required this.en,
      required this.wordComponents,
      required this.idx});

  // 連想配列からロード
  factory Sentence.fromJson(Map<String, dynamic> json) {
    // List<Person> people = jsonData.map((json) => Person.fromJson(json)).toList();
    List<dynamic> wordIds = json["wordIds"];
    List<Word> wordComponents =
        wordIds.map((idx) => getWordByIdx(idx)).toList();
    return Sentence(
      la: json["la"],
      en: json["en"],
      wordComponents: wordComponents,
      idx: json["idx"],
    );
  }
}

class SentenceMeta {
  int sentenceIdx;
  List<int> score;
  List<String> tags;

  SentenceMeta(
      {required this.sentenceIdx, required this.tags, required this.score});

  // 連想配列からロード
  factory SentenceMeta.fromJson(Map<String, dynamic> json,
      {required Map<int, String> tag}) {
    return SentenceMeta(
      sentenceIdx: json["sentenceIdx"],
      score: json["score"].cast<int>(),
      tags: json["tags"]
          .cast<int>()
          .map((tagId) => tag[tagId])
          .cast<String>()
          .toList(),
    );
  }
}
