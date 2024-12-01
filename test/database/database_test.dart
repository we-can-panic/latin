import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:latin/repositories/database/database.dart';

import 'package:latin/models/noun.dart';
import 'package:latin/models/verb.dart';
import 'package:latin/models/nounComponent.dart';
import 'package:latin/models/verbComponent.dart';
import 'package:latin/models/sentence.dart';

import 'components.dart';

void main() {
  late Database database;
  setUpAll(() async {
    sqfliteTestInit();
    database = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async =>
          await AppDatabase().createDatabase(db, version),
    );
  });

  tearDownAll(() async {
    database.close();
  });

  group("DataBase", () {
    test("DB作成", () async {
      var tableNames = (await database
              .query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
          .map((row) => row['name'] as String)
          .toList(growable: false);
      expect(tableNames, contains(sentenceTable));
      expect(tableNames, contains(nounComponentTable));
      expect(tableNames, contains(verbComponentTable));
      expect(tableNames, contains(nounTable));
      expect(tableNames, contains(verbTable));
    });
    test("ロード", () async {
      final nounData = await loadNounData();
      final verbData = await loadVerbData();
      final nounComponentData = await loadNounComponentData(nounData);
      final verbComponentData = await loadVerbComponentData(verbData);
      final sentenceData =
          await loadSentenceData(nounComponentData, verbComponentData);

      expect(verbData.length > 1, isTrue);
      expect(nounData.length > 1, isTrue);
      expect(verbComponentData.length > 1, isTrue);
      expect(nounComponentData.length > 1, isTrue);
      expect(sentenceData.length > 1, isTrue);
    });
  });
}
