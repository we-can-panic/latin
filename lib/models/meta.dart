// メタデータクラス
import 'package:latin/models/word.dart';

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

class NounMeta extends WordMeta {
  NounMeta({required super.wordIdx, required super.tags, required super.score});

  factory NounMeta.fromWord(WordMeta wm) {
    return NounMeta(wordIdx: wm.wordIdx, tags: wm.tags, score: wm.score);
  }

  // 連想配列からロード
  @override
  factory NounMeta.fromJson(Map<String, dynamic> json,
      {required Map<int, String> tag}) {
    return NounMeta.fromWord(WordMeta.fromJson(json, tag: tag));
  }
}

class VerbMeta extends WordMeta {
  VerbMeta({required super.wordIdx, required super.tags, required super.score});

  factory VerbMeta.fromWord(WordMeta wm) {
    return VerbMeta(wordIdx: wm.wordIdx, tags: wm.tags, score: wm.score);
  }

  // 連想配列からロード
  @override
  factory VerbMeta.fromJson(Map<String, dynamic> json,
      {required Map<int, String> tag}) {
    return VerbMeta.fromWord(WordMeta.fromJson(json, tag: tag));
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
