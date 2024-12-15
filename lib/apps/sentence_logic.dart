import 'package:flutter/foundation.dart';
import 'package:latin/models/enumeration.dart';
import 'package:latin/models/noun.dart';
import 'package:latin/models/nounComponent.dart';
import 'package:latin/models/verb.dart';
import 'package:latin/models/verbComponent.dart';
import 'package:latin/apps/noun.dart';
import 'package:latin/apps/verb.dart';
import 'package:latin/apps/sentence.dart';
import 'package:latin/models/sentence.dart';

int currentIdx = 0;
List<Sentence> currentSentenceData = [];
bool questionByLa = false;

Sentence sentence = getNextSentence();
List<NounComponent> candidateNouns = getRandomNounComponents(num: 4);
List<VerbComponent> candidateVerbs = getRandomVerbComponents(num: 4);
List<NounOrVerb> candidateWords = []; // 未選択の単語
List<NounOrVerb> selectedWords = []; // 選択済みの単語

enum WordType { verb, noun }

class NounOrVerb {
  WordType type;
  NounComponent nounComponent;
  VerbComponent verbComponent;

  NounOrVerb({
    required this.type,
    required this.nounComponent,
    required this.verbComponent,
  });

  String get la => type == WordType.noun ? nounComponent.la : verbComponent.la;
  String get en => type == WordType.noun ? nounComponent.en : verbComponent.en;

  // 名詞の場合: 格変化 / 格変化名+数の5*3のテーブル、
  // 動詞の場合: 人称 / 人称名+数の3*4のテーブル、
  // を生成
  List<List<String>> conjugateAll(Mode m, Form f, Tense t) {
    List<List<String>> result = [];
    switch (type) {
      case WordType.noun:
        Noun noun = nounComponent.noun;
        NounCase.values.asMap().forEach((int i, NounCase c) {
          result.add([
            c.name,
            noun.conjugate(c, Numbers.single),
            noun.conjugate(c, Numbers.multi)
          ]);
        });
        break;
      case WordType.verb:
        Verb verb = verbComponent.verb;
        Person.values.asMap().forEach((int i, Person p) {
          result.add([
            "${i + 1}",
            verb.conjugate(m, f, t, p, Numbers.single),
            verb.conjugate(m, f, t, p, Numbers.multi),
          ]);
        });
        break;
      default:
        throw ErrorDescription("WordType is not defined.");
    }
    return result;
  }
}

String getQuestion(NounOrVerb nv) {
  switch (nv.type) {
    case WordType.verb:
      final verb = nv.verbComponent;
      if (questionByLa) {
        return verb.en;
      } else {
        return verb.la;
      }
    case WordType.noun:
      final noun = nv.nounComponent;
      if (questionByLa) {
        return noun.en;
      } else {
        return noun.la;
      }
  }
}

// 各種値をリセットし整合性の結果を返す
bool resetCurrentSentenceData() {
  currentIdx = 0;
  currentSentenceData = sentenceData;
  currentSentenceData.shuffle();
  moveNext();
  // 整合性: currentSentenceDataが0でないこと
  return currentSentenceData.isNotEmpty;
}

bool moveNext() {
  sentence = getNextSentence();
  candidateNouns = getRandomNounComponents(num: 2);
  candidateNouns.addAll(sentence.nounComponents);
  candidateVerbs = getRandomVerbComponents(num: 2);
  candidateVerbs.addAll(sentence.verbComponents);
  candidateWords = [];
  for (var n in candidateNouns) {
    candidateWords.add(NounOrVerb(
        type: WordType.noun,
        nounComponent: n,
        verbComponent: defaultVerbComponent));
  }
  for (var v in candidateVerbs) {
    candidateWords.add(NounOrVerb(
        type: WordType.verb,
        nounComponent: defaultNounComponent,
        verbComponent: v));
  }
  candidateWords.sort((a, b) => getQuestion(a).compareTo(getQuestion(b)));
  selectedWords = [];
  return true;
}

// 次の単語を返す
Sentence getNextSentence() {
  if (currentSentenceData.isEmpty) {
    return defaultSentence;
  }
  if (currentIdx < currentSentenceData.length) {
    Sentence result = currentSentenceData[currentIdx];
    currentIdx++;
    return result;
  } else {
    currentIdx = 0;
    return getNextSentence();
  }
}

List<Sentence> getRandomSentences() {
  List<Sentence> sentences = List.from(sentenceData);
  sentences.shuffle();
  return sentences.sublist(0, 7).toList();
}

// selectedWordsがSentenceと合致しているか確認
bool isCorrect(Sentence sentence, List<NounOrVerb> selectedWords) {
  Set<String> seletedLatins = selectedWords
      .map((w) =>
          w.type == WordType.noun ? w.nounComponent.la : w.verbComponent.la)
      .toSet();
  Set<String> correctLatins = sentence.nounComponents
      .map((n) => n.la)
      .toSet()
      .union(sentence.verbComponents.map((n) => n.la).toSet());

  return seletedLatins.containsAll(correctLatins);
}
