import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'verb.dart';
import 'word.dart';

List<Verb> verbData = []; // 全てのVerbデータ

Future<void> loadVerbData() async {
  String verbStr = await rootBundle.loadString('assets/verb.json');
  List<dynamic> verb = jsonDecode(verbStr);
  verbData = verb.map((json) => Verb.fromJson(json)).toList();
}

// 特定のidxのverbを取得
Verb getVerbByIdx(int idx) {
  for (var w in verbData) {
    if (idx == w.idx) {
      return w;
    }
  }
  return Verb(la: "", en: "", num: "1", idx: -1);
}

List<Verb> getRandomVerbs({int num = 7}) {
  List<Verb> verbs = List.from(verbData);
  verbs.shuffle();
  return verbs.sublist(0, num).toList();
}

String getRandomConjugatedVerb(Verb verb) {
  Mode m = Mode.values[random.nextInt(Mode.values.length)];
  Form f = Form.values[random.nextInt(Form.values.length)];
  Tense t = Tense.values[random.nextInt(Tense.values.length)];
  Person p = Person.values[random.nextInt(Person.values.length)];
  Numbers n = Numbers.values[random.nextInt(Numbers.values.length)];
  return getVerbConjugate(verb, m: m, f: f, t: t, p: p, n: n);
}

// 単語の活用
String getVerbConjugate(Verb verb,
    {Mode m = Mode.indicative,
    Form f = Form.active,
    Tense t = Tense.present,
    Person p = Person.first,
    Numbers n = Numbers.single}) {
  return verb.la;
}

Random random = Random();
