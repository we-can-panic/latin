import 'package:flutter_test/flutter_test.dart';
import 'package:latin/models/sentence.dart';
import 'package:latin/models/nounComponent.dart';
import 'package:latin/models/verbComponent.dart';
import 'package:latin/models/noun.dart';
import 'package:latin/models/verb.dart';
import 'package:latin/models/enumeration.dart';

void main() {
  group('Sentence', () {
    test('fromJson creates a valid Sentence object', () {
      final json = {
        "id": 1,
        "la": "Lorem",
        "en": "Lorem",
        "nounComponents": "1;2",
        "verbComponents": "3;4"
      };

      // ラテン語の名詞もしくは形容詞を表すクラスのインスタンスのリスト
      // このリストは、文章の構成要素としての名詞や形容詞を表す
      final nounComponents = [
        // mater
        NounComponent(
            id: 1,
            noun: Noun(
                id: 1,
                la: "mater",
                en: "mother",
                nounType: NounType.noun,
                conjugateType: NounConjugateType.nt3,
                sex: SexType.f),
            nounCase: NounCase.nom,
            num: Numbers.single),
        // pater
        NounComponent(
            id: 2,
            noun: Noun(
                id: 2,
                la: "pater",
                en: "father",
                nounType: NounType.noun,
                conjugateType: NounConjugateType.nt3,
                sex: SexType.m),
            nounCase: NounCase.nom,
            num: Numbers.single),
      ];

      final verbComponents = [
        VerbComponent(
          id: 3,
          verb: Verb(
              id: 3,
              la: "amo",
              en: "love",
              conjugateType: VerbConjugateType.vt1),
          mode: Mode.indicative,
          form: Form.active,
          tense: Tense.present,
          person: Person.first,
          num: Numbers.single,
        ),
        VerbComponent(
          id: 4,
          verb: Verb(
              id: 4,
              la: "video",
              en: "see",
              conjugateType: VerbConjugateType.vt2),
          mode: Mode.indicative,
          form: Form.active,
          tense: Tense.present,
          person: Person.first,
          num: Numbers.single,
        ),
      ];

      final sentence = Sentence.fromJson(json, nounComponents, verbComponents);

      expect(sentence.id, 1);
      expect(sentence.la, "Lorem");
      expect(sentence.en, "Lorem");
      expect(sentence.nounComponents.length, 2);
      expect(sentence.verbComponents.length, 2);
    });
  });
}
