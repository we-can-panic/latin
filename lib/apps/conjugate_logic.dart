import 'package:latin/apps/noun.dart';
import 'package:latin/models/noun.dart';

int currentIdx = 0;
List<Noun> currentNounData = []; // Conjugateの条件のみを抜き出したnounData

// 各種値をリセットし整合性の結果を返す
bool resetCurrentNounData() {
  currentIdx = 0;
  currentNounData = nounData;
  currentNounData.shuffle();
  // 整合性: currentNounDataが0でないこと
  return currentNounData.isNotEmpty;
}

// 次の単語を返す
Noun getNextNoun() {
  if (currentNounData.isEmpty) {
    return defaultNoun;
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
