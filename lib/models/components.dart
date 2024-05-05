import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:latin/models/word.dart';
import 'package:latin/models/tag.dart';
import 'package:latin/models/sentence.dart';

// 前処理
Future<void> init() async {
  String wordStr = await rootBundle.loadString('assets/word.json');
  String sentenceStr = await rootBundle.loadString('assets/sentence.json');
  String wordMetaStr = await rootBundle.loadString('assets/word_meta.json');
  String sentenceMetaStr =
      await rootBundle.loadString('assets/sentence_meta.json');
  String tagStr = await rootBundle.loadString("assets/tags.json");

  List<dynamic> word = jsonDecode(wordStr);
  List<dynamic> sentence = jsonDecode(sentenceStr);
  List<dynamic> wordMeta = jsonDecode(wordMetaStr);
  List<dynamic> sentenceMeta = jsonDecode(sentenceMetaStr);
  List<dynamic> tag = jsonDecode(tagStr);

  wordData = word.map((json) => Word.fromJson(json)).toList();
  sentenceData = sentence.map((json) => Sentence.fromJson(json)).toList();
  tagData = tagDataFromJson(tag);
  wordMetaData =
      wordMeta.map((json) => WordMeta.fromJson(json, tag: tagData)).toList();
  sentenceMetaData = sentenceMeta
      .map((json) => SentenceMeta.fromJson(json, tag: tagData))
      .toList();

  wordData.shuffle();
}
