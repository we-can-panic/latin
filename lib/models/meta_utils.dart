import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:latin/models/sentence.dart';
import 'meta.dart';
import 'noun.dart';
import 'verb.dart';

List<NounMeta> nounMetaData = [];
List<VerbMeta> verbMetaData = [];
List<SentenceMeta> sentenceMetaData = [];
Map<int, String> tagData = {};

Future<void> loadMetaData() async {
  String nmStr = await rootBundle.loadString('assets/noun_meta.json');
  String vmStr = await rootBundle.loadString('assets/verb_meta.json');
  String smStr = await rootBundle.loadString('assets/sentence_meta.json');
  List<dynamic> nmjson = jsonDecode(nmStr);
  List<dynamic> vmjson = jsonDecode(vmStr);
  List<dynamic> smjson = jsonDecode(smStr);
  nounMetaData =
      nmjson.map((json) => NounMeta.fromJson(json, tag: tagData)).toList();
  verbMetaData =
      vmjson.map((json) => VerbMeta.fromJson(json, tag: tagData)).toList();
  sentenceMetaData =
      smjson.map((json) => SentenceMeta.fromJson(json, tag: tagData)).toList();
}

Future<void> loadTagData() async {
  String tagStr = await rootBundle.loadString('assets/tags.json');
  List<dynamic> json = jsonDecode(tagStr);
  tagData = _tagDataFromJson(json);
}

/// input: [{id: 1, name: tag1}, {id: 2, name: tag2}]
/// output: {1: tag1, 2: tag2}
Map<int, String> _tagDataFromJson(List<dynamic> json) {
  Map<int, String> result = {};
  for (var data in json) {
    int id = data["id"];
    String name = data["name"];
    result[id] = name;
  }
  return result;
}

// Verbに紐づいているTagを取得
List<String> getNounTag(Noun noun) {
  for (var m in nounMetaData) {
    if (m.wordIdx == noun.idx) {
      return m.tags;
    }
  }
  return [];
}

// Verbに紐づいているTagを取得
List<String> getVerbTag(Verb verb) {
  for (var m in verbMetaData) {
    if (m.wordIdx == verb.idx) {
      return m.tags;
    }
  }
  return [];
}

// Sentenceに紐づいているTagを取得
List<String> getSentenceTag(Sentence sentence) {
  for (var m in sentenceMetaData) {
    if (m.sentenceIdx == sentence.idx) {
      return m.tags;
    }
  }
  return [];
}
