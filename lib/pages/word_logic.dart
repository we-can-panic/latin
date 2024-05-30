import 'package:latin/models/meta_utils.dart';
import 'package:latin/models/noun.dart';
import 'package:latin/models/noun_utils.dart';

int currentIdx = 0;
List<Noun> currentNounData = [];
List<String> currentTagData = tagData.values.toList();
bool questionByLa = false;

// 各種値をリセットし整合性の結果を返す
bool resetCurrentNounData() {
  currentIdx = 0;
  currentNounData = filterNounData(nounData, currentTagData);
  currentNounData.shuffle();
  // 整合性: currentNounDataが0でないこと
  return currentNounData.isNotEmpty;
}

// 次の単語を返す
Noun getNextNoun() {
  if (currentNounData.isEmpty) {
    return Noun(
        la: "", en: "", type: NounType.noun, num: "", sex: SexType.m, idx: 0);
  }
  if (currentIdx < currentNounData.length) {
    Noun result = currentNounData[currentIdx];
    currentIdx++;
    return result;
  } else {
    currentIdx = 0;
    return getNextNoun();
  }
}

List<Noun> filterNounData(List<Noun> nounData, List<String> currentTagData) {
  List<Noun> result = nounData;

  bool addEmpty = currentTagData.contains("タグなし");
  Set<String> tagSet = currentTagData.toSet();
  result = result.where((item) {
    Set<String> currentTagSets = getNounTag(item).toSet();
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

String toQuestion(Noun noun) {
  if (questionByLa) {
    return noun.la;
  } else {
    return noun.en;
  }
}

String toAnswer(Noun noun) {
  if (questionByLa) {
    return noun.en;
  } else {
    return noun.la;
  }
}
