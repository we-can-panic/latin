import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Initialize sqflite for test.
void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  TestWidgetsFlutterBinding.ensureInitialized();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
}
