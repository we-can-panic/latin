import 'package:flutter_test/flutter_test.dart';
import 'package:latin/database/database.dart';

import 'package:latin/models/noun.dart';
import 'package:latin/models/meta.dart';
import 'package:latin/models/verb.dart';
import 'package:latin/models/sentence.dart';

void main() {
  loadNounData();

  group("DB", () {
    test("ロード", () async {
      await loadTagData();
      await loadVerbData();
      await loadNounData();
      await loadSentenceData();

      expect(verbData.length > 1, isTrue);
      expect(nounData.length > 1, isTrue);
      expect(sentenceData.length > 1, isTrue);
    });
  });
}
