import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'sentence.dart';

List<Sentence> sentenceData = [];

Future<void> loadSentenceData() async {
  String sentenceStr = await rootBundle.loadString('assets/sentence.json');
  List<dynamic> sentence = jsonDecode(sentenceStr);
  sentenceData = sentence.map((json) => Sentence.fromJson(json)).toList();
}
