import 'package:flutter_test/flutter_test.dart';
import 'package:latin/models/nounComponent.dart';
import 'package:latin/models/noun.dart';
import 'package:latin/models/enumeration.dart';

void main() {
  group('NounComponent', () {
    test('fromJson creates a valid NounComponent object', () {
      final json = {"id": 1, "nounId": 1, "nounCase": 0, "num": 0};

      final nounData = [
        Noun(
            id: 1,
            la: "mater",
            en: "mother",
            nounType: NounType.noun,
            conjugateType: NounConjugateType.nt3,
            sex: SexType.f)
      ];

      final nounComponent = NounComponent.fromJson(json, nounData);

      expect(nounComponent.id, 1);
      expect(nounComponent.noun.id, 1);
      expect(nounComponent.noun.la, "mater");
      expect(nounComponent.noun.en, "mother");
      expect(nounComponent.noun.nounType, NounType.noun);
      expect(nounComponent.noun.conjugateType, NounConjugateType.nt3);
      expect(nounComponent.noun.sex, SexType.f);
      expect(nounComponent.nounCase, NounCase.nom);
      expect(nounComponent.num, Numbers.single);
    });
  });
}
