import 'package:latin/models/enumeration.dart';
import 'package:latin/models/nounComponent.dart';
import 'package:test/test.dart';
import 'package:latin/models/noun.dart';
import 'package:latin/models/nounComponent.dart';

void main() async {
  // await init();
  test('canis conjugate', () {
    expect(
        NounComponent(
          id: -1,
          noun: Noun.fromJson({
            "id": 10,
            "la": "Canis",
            "en": "Dog",
            "nounType": 0,
            "conjugateType": 2,
            "sex": 1,
          }),
          nounCase: NounCase.acc,
          num: Numbers.multi,
        ).la,
        "Canēs");
  });
}
