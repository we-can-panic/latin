import 'package:latin/models/noun_utils.dart';
import 'package:latin/models/word.dart';
import 'package:test/test.dart';
import 'package:latin/models/noun.dart';

void main() async {
  // await init();
  test('canis conjugate', () {
    expect(
        getNounConjugate(
            Noun.fromJson({
              "la": "Canis",
              "en": "Dog",
              "type": "noun",
              "num": "3",
              "sex": "m",
              "idx": 10
            }),
            NounConjugateType.acc,
            Numbers.multi,
            SexType.m),
        "Canēs");
  });
}
