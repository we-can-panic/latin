// 読み込みとか
import "package:latin/apps/sentence.dart";
import "package:latin/apps/verb.dart";
import "package:latin/apps/noun.dart";
import "package:latin/models/sentence.dart";
import "package:latin/models/verb.dart";
import "package:latin/models/noun.dart";
import "package:latin/models/verbComponent.dart";
import "package:latin/models/nounComponent.dart";

Future<void> loadAssets() async {
  nounData = await loadNounData();
  verbData = await loadVerbData();
  nounComponentData = await loadNounComponentData(nounData);
  verbComponentData = await loadVerbComponentData(verbData);
  sentenceData = await loadSentenceData(nounComponentData, verbComponentData);
}
