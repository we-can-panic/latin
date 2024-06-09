import 'package:latin/models/nounComponent.dart';
import 'package:latin/models/verbComponent.dart';
import 'package:latin/models/word.dart';
import 'package:latin/models/noun.dart';
import 'package:latin/models/verb.dart';
import 'package:latin/models/sentence.dart';
import 'package:latin/models/meta.dart';

int currentIdx = 0;
List<Sentence> currentSentenceData = [];
List<String> currentTagData = tagData.values.toList();
bool questionByLa = false;

Sentence sentence = getNextSentence();
List<NounComponent> candidateNouns = getRandomNounComponents(num: 4);
List<VerbComponent> candidateVerbs = getRandomVerbComponents(num: 4);
List<NounOrVerb> candidateWords = []; // 未選択の単語
List<NounOrVerb> selectedWords = []; // 選択済みの単語

enum WordType { verb, noun }

class NounOrVerb {
  WordType type;
  int idx;
  NounOrVerb({required this.type, required this.idx});
}

String getQuestion(NounOrVerb nv) {
  Word word;
  switch (nv.type) {
    case WordType.verb:
      word = candidateVerbs[nv.idx].verb;
      break;
    case WordType.noun:
      word = candidateNouns[nv.idx].noun;
      break;
  }
  if (questionByLa) {
    return word.en;
  } else {
    return word.la;
  }
}

// 各種値をリセットし整合性の結果を返す
bool resetCurrentSentenceData() {
  currentIdx = 0;
  currentSentenceData = filterSentenceData(sentenceData, currentTagData);
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
  for (var i = 0; i < candidateNouns.length; i++) {
    candidateWords.add(NounOrVerb(type: WordType.noun, idx: i));
  }
  for (var i = 0; i < candidateVerbs.length; i++) {
    candidateWords.add(NounOrVerb(type: WordType.verb, idx: i));
  }
  candidateWords.sort((a, b) => getQuestion(a).compareTo(getQuestion(b)));
  selectedWords = [];
  return true;
}

// 次の単語を返す
Sentence getNextSentence() {
  if (currentSentenceData.isEmpty) {
    return Sentence(
        la: "",
        en: "",
        nounComponents: [],
        verbComponents: [],
        idx: 0,
        meta: Meta(score: [], tags: []));
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

List<Sentence> filterSentenceData(
    List<Sentence> sentenceData, List<String> currentTagData) {
  List<Sentence> result = sentenceData;

  bool addEmpty = currentTagData.contains("タグなし");
  Set<String> tagSet = currentTagData.toSet();
  result = result.where((item) {
    Set<String> currentTagSets = item.meta.tags.toSet();
    currentTagSets.remove("");
    if (addEmpty && currentTagSets.isEmpty) {
      return true;
    } else if (tagSet.intersection(currentTagSets).isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }).toList();

  return result;
}

List<Sentence> getRandomSentences() {
  List<Sentence> sentences = List.from(sentenceData);
  sentences.shuffle();
  return sentences.sublist(0, 7).toList();
}
