import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:latin/database/database.dart';

/// Initialize sqflite for test.
void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
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
  });
}
