import 'package:path/path.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

AppDatabase db = AppDatabase();

// DB の各列の名前
const String sentenceTable = "sentence";
const String nounComponentTable = "nounComponent";
const String verbComponentTable = "verbComponent";
const String nounTable = "noun";
const String verbTable = "verb";

class AppDatabase {
  Database? _db;

  Future<Database> get database async => _db ??= await open();

  Future open() async {
    // databaseFactory = databaseFactoryFfi;
    return await openDatabase(
      join(await getDatabasesPath(), "latin.db"),
      version: 1,
      // データベース作成時処理
      onCreate: (db, version) async => await createDatabase(db, version),
    );
  }

  // データベース作成
  Future<void> createDatabase(Database db, int version) async {
    // 各テーブルを作成する SQL を実行
    await db.execute('''
create table $sentenceTable (
  id integer primary key autoincrement,
  la text not null,
  en text not null,
  nounComponents text,
  verbComponents text
)''');
    await db.execute('''
create table $nounComponentTable (
  id integer primary key autoincrement,
  nounId integer not null,
  nounCase integer not null,
  num integer not null,
  foreign key (nounId)
    references Source ($nounTable)
    on delete cascade
)''');
    await db.execute('''
create table $verbComponentTable (
  id integer primary key autoincrement,
  verbId integer not null,
  mode integer not null,
  form integer not null,
  tense integer not null,
  person integer not null,
  num integer not null,
  foreign key (verbId)
    references Source ($verbTable)
    on delete cascade
)''');
    await db.execute('''
create table $nounTable (
  id integer primary key autoincrement,
  la text not null,
  en text not null,
  nounType integer not null,
  conjugateType integer not null,
  sex integer not null
)''');
    await db.execute('''
create table $verbTable (
  id integer primary key autoincrement,
  la text not null,
  en text not null,
  conjugateType integer not null
)''');

    await registData(db);
  }

  Future<void> getAll(Database db, int version) async {}

  insert(String table, map) async {
    (await database).insert(table, map);
  }
}

// 登録
Future<void> registData(Database db) async {
  List<String> files = [
    nounTable,
    nounComponentTable,
    sentenceTable,
    verbTable,
    verbComponentTable,
  ];

  const csvToListConverter = CsvToListConverter();

  for (var tableName in files) {
    final input =
        await rootBundle.loadString("assets/ラテン語シート - $tableName.csv");
    final fields = csvToListConverter.convert(input);

    final List<String> columnNames = List<String>.from(fields.first);

    // 行頭はSkip
    final dataRows = fields.skip(1);
    // データ一括挿入
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var row in dataRows) {
        final rowMap = Map<String, dynamic>.fromIterables(columnNames, row);
        batch.insert(tableName, rowMap);
      }
      await batch.commit(noResult: true);
    });
  }
}
