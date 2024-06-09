import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:latin/database/database.dart';

import 'package:latin/models/noun.dart';
import 'package:latin/models/meta.dart';
import 'package:latin/models/verb.dart';
import 'package:latin/models/sentence.dart';

/// Initialize sqflite for test.
void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  TestWidgetsFlutterBinding.ensureInitialized();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
}

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
      expect(tableNames, contains(metaTable));
    });
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
