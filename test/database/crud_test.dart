// // 登録

// // 登録確認

// // 変更

// // 変更確認

// // 削除

// // 削除確認

import 'package:flutter_test/flutter_test.dart';
import 'package:latin/repositories/database/database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    // Set the database factory
    databaseFactory = databaseFactoryFfi;
  });

  group('DataBase', () {
    test('DB作成', () async {
      final dbclient = await db.database;
      expect(dbclient, isNotNull);
    });

    test('ロード', () async {
      final dbclient = await db.database;
      expect(dbclient, isNotNull);
    });
  });
}

// import 'package:flutter_test/flutter_test.dart';
// import 'package:latin/models/noun.dart';
// import 'package:latin/models/nounComponent.dart';
// import 'package:latin/models/verb.dart';
// import 'package:latin/models/verbComponent.dart';
// import 'package:latin/models/sentence.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:latin/repositories/database/database.dart';

// import 'components.dart';

// void main() {
//   late Database database;
//   setUpAll(() async {
//     sqfliteTestInit();
//     database = await openDatabase(
//       inMemoryDatabasePath,
//       version: 1,
//       onCreate: (db, version) async =>
//           await AppDatabase().createDatabase(db, version),
//     );
//   });

//   tearDownAll(() async {
//     database.close();
//   });

//   test('insert and retrieve a sentence', () async {
//     final sentence = makeSampleSentence();

//     final id = await registSentence(sentence);
//     final retrievedSentence = await getSentenceById(id);

//     expect(retrievedSentence.id, id);
//     expect(retrievedSentence.en, 'Hello');
//     expect(retrievedSentence.la, 'Salve');
//   });

//   test('update a sentence', () async {
//     final sentence = makeSampleSentence();

//     final id = await registSentence(sentence);
//     final updatedSentence = makeSampleSentence(id: id, en: "Hi");

//     final success = await updateSentence(updatedSentence);
//     final retrievedSentence = await getSentenceById(id);

//     expect(success, true);
//     expect(retrievedSentence.en, 'Hi');
//     expect(retrievedSentence.la, 'Salve');
//   });

//   test('delete a sentence', () async {
//     final sentence = makeSampleSentence();

//     final id = await registSentence(sentence);
//     final deleteCount = await deleteSentence(id);
//     final retrievedSentence = await getSentenceById(id);

//     expect(deleteCount, 1);
//     expect(retrievedSentence, null);
//   });
// }

// Sentence makeSampleSentence({int id = 0, String en = "Hello"}) {
//   return Sentence(
//     la: "Salve",
//     en: en,
//     nounComponents: [
//       NounComponent(
//           noun: Noun(
//               la: "l",
//               en: "e",
//               type: NounType.noun,
//               num: "3",
//               sex: SexType.f,
//               idx: 0,
//               meta: Meta(score: [0, 0, 0, 0, 0], tags: ["0", "0", "0", "0"])),
//           conjugateType: NounConjugateType.nom,
//           num: Numbers.single)
//     ],
//     verbComponents: [
//       VerbComponent(
//           verb: Verb(
//               la: "l",
//               en: "e",
//               num: "3",
//               idx: 0,
//               meta: Meta(score: [0, 0, 0, 0, 0], tags: ["0", "0", "0", "0"])),
//           num: Numbers.single,
//           mode: Mode.indicative,
//           form: Form.active,
//           tense: Tense.past,
//           person: Person.first)
//     ],
//     idx: id,
//     meta: Meta(score: [0, 0, 0, 0, 0], tags: ["0", "0", "0", "0"]),
//   );
// }
