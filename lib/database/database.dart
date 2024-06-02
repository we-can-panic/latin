import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
      version: 2,
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
  }

  Future<void> getAll(Database db, int version) async {}
}
