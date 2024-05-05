import 'package:latin/utils/latinutils.dart';
import 'package:latin/models/word.dart';
import 'package:latin/models/tag.dart';

int currentIdx = 0;
List<Word> currentWordData = [];
List<String> currentTagData = tagData.values.toList();
bool questionByLa = false;

// 各種値をリセットし整合性の結果を返す
bool resetCurrentWordData() {
  currentIdx = 0;
  currentWordData = filterWordData(wordData, currentTagData);
  currentWordData.shuffle();
  // 整合性: currentWordDataが0でないこと
  return currentWordData.isNotEmpty;
}

// 次の単語を返す
Word getNextWord() {
  if (currentWordData.isEmpty) {
    return Word(
        la: "", en: "", type: WordType.noun, num: "", sex: SexType.m, idx: 0);
  }
  if (currentIdx < currentWordData.length) {
    Word result = currentWordData[currentIdx];
    currentIdx++;
    return result;
  } else {
    currentIdx = 0;
    return getNextWord();
  }
}

List<Word> filterWordData(List<Word> wordData, List<String> currentTagData) {
  List<Word> result = wordData;

  bool addEmpty = currentTagData.contains("タグなし");
  Set<String> tagSet = currentTagData.toSet();
  result = result.where((item) {
    Set<String> currentTagSets = getTag(item).toSet();
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

String toQuestion(Word word) {
  if (questionByLa) {
    return word.la;
  } else {
    return word.en;
  }
}

String toAnswer(Word word) {
  if (questionByLa) {
    return word.en;
  } else {
    return word.la;
  }
}
