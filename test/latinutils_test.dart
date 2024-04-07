import 'package:test/test.dart';
import 'package:latin/latinutils.dart';

void main() async {
  // await init();
  test('canis conjugate', () {
    expect(
        getNounConjugate(
            Word.fromJson({
              "la": "Canis",
              "en": "Dog",
              "type": "noun",
              "num": "3",
              "sex": "m",
              "idx": 10
            }),
            NounConjugateType.acc,
            MultiType.multi,
            SexType.m),
        "Canēs");
  });
}
