import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

AppDatabase db = AppDatabase();

// DB の各列の名前
const String sentenceTable = "sentence";
const String nounComponentTable = "nounComponent";
const String verbComponentTable = "verbComponent";
const String nounTable = "noun";
const String verbTable = "verb";
const String metaTable = "meta";
const String tagTable = "tag";

class AppDatabase {
  Database? _db;

  Future<Database> get database async => _db ??= await open();

  Future open() async {
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
  conjugate integer not null,
  number integer not null,
  foreign key (nounId)
    references Source ($nounTable)
    on delete cascade
)''');
    await db.execute('''
create table $verbComponentTable (
  id integer primary key autoincrement,
  verbId integer not null,
  number integer not null,
  mode integer not null,
  form integer not null,
  tense integer not null,
  person integer not null,
  foreign key (verbId)
    references Source ($verbTable)
    on delete cascade
)''');
    await db.execute('''
create table $nounTable (
  id integer primary key autoincrement,
  la text not null,
  en text not null,
  num text not null,
  nounType integer not null,
  sex integer not null
)''');
    await db.execute('''
create table $verbTable (
  id integer primary key autoincrement,
  la text not null,
  en text not null,
  num text not null
)''');
    await db.execute('''
create table $metaTable (
  id integer primary key autoincrement,
  kind text not null,
  rowId integer not null,
  score text,
  tags text
)''');
    await db.execute('''
create table $tagTable (
  id integer primary key autoincrement,
  name text not null
)''');

    await registData(db);
  }

  Future<void> getAll(Database db, int version) async {}
}

// 登録
Future<void> registData(Database db) async {
  List<String> files = [
    metaTable,
    nounTable,
    nounComponentTable,
    sentenceTable,
    tagTable,
    verbTable,
    verbComponentTable,
  ];

  const csvToListConverter = CsvToListConverter();

  for (var tableName in files) {
    // CSVファイルを読み込み
    // final input = File("assets/$tableName.csv").openRead();
    // final fields = await input
    //     .transform(utf8.decoder)
    //     .transform(const CsvToListConverter())
    //     .toList();

    final input = await rootBundle.loadString("assets/$tableName.csv");
    final fields = csvToListConverter.convert(input);

    // 最初の行はカラム名
    // final columnNames = fields.first;
    final List<String> columnNames = List<String>.from(fields.first);

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
