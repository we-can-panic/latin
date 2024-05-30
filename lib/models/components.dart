import 'verb_utils.dart';
import 'noun_utils.dart';
import 'meta_utils.dart';
import 'sentence_utils.dart';

// 前処理
Future<void> init() async {
  await loadTagData();
  await loadVerbData();
  await loadNounData();
  await loadSentenceData();
  await loadMetaData();
}
