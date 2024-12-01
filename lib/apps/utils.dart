import 'package:latin/models/enumeration.dart';
import 'dart:math';

final random = Random();

Numbers getRandomNumbers() {
  return Numbers.values[random.nextInt(Numbers.values.length)];
}
