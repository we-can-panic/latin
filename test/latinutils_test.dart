import 'package:latin/models/nounComponent.dart';
import 'package:latin/models/word.dart';
import 'package:test/test.dart';
import 'package:latin/models/noun.dart';

void main() async {
  // await init();
  test('canis conjugate', () {
    expect(
        NounComponent(
          noun: Noun.fromJson({
            "la": "Canis",
            "en": "Dog",
            "type": "noun",
            "num": "3",
            "sex": "m",
            "idx": 10
          }),
          conjugateType: NounConjugateType.acc,
          num: Numbers.multi,
        ).la,
        "Canēs");
  });
}
