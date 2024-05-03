import "../utils/latinutils.dart";

int currentIdx = 0;
List<Sentence> currentSentenceData = [];
List<String> currentTagData = tagData.values.toList();
bool questionByLa = false;

Sentence sentence = getNextSentence();
List<Word> candidateWords = getRandomWords(num: 4);
List<Word> selectedWords = [];

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
  candidateWords = getRandomWords(num: 4);
  candidateWords.addAll(sentence.wordComponents);
  candidateWords.sort((a, b) => (a.la).compareTo(b.la));
  selectedWords = [];
  return true;
}

// 次の単語を返す
Sentence getNextSentence() {
  if (currentSentenceData.isEmpty) {
    return Sentence(la: "", en: "", wordComponents: [], idx: 0);
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
    Set<String> currentTagSets = getTagOfSentence(item).toSet();
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
