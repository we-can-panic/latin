import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latin/models/verbComponent.dart';
import 'package:latin/models/verb.dart';
import 'package:latin/models/enumeration.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // テストデータを直接JSONとして定義
    const String jsonString = '''
{
  "vt1": {
    "indicative": {
      "active": {
        "present": {
          "single": ["o", "as", "at"],
          "multi": ["amus", "atis", "ant"]
        }
      }
    }
  },
  "vt2": {
    "indicative": {
      "active": {
        "past": {
          "single": ["ebam", "ebas", "ebat"],
          "multi": ["ebamus", "ebatis", "ebant"]
        }
      }
    }
  },
  "vt3": {
    "indicative": {
      "passive": {
        "present": {
          "single": ["or", "eris", "itur"],
          "multi": ["imur", "imini", "untur"]
        }
      }
    }
  },
  "vt3i": {
    "subjunctive": {
      "active": {
        "present": {
          "single": ["iam", "ias", "iat"],
          "multi": ["iamus", "iatis", "iant"]
        }
      },
      "passive": {
        "present": {
          "single": ["iar", "iaris", "iatur"],
          "multi": ["iamur", "iamini", "iantur"]
        }
      }
    }
  },
  "vt4": {
    "indicative": {
      "active": {
        "presentPerfect": {
          "single": ["ivi", "ivisti", "ivit"],
          "multi": ["ivimus", "ivistis", "iverunt"]
        }
      }
    }
  }
}''';

    // テストデータを直接設定
    verbConjugateRules = jsonDecode(jsonString);
  });

  group('VerbComponent', () {
    test('fromJson creates a valid VerbComponent object', () {
      final json = {
        "id": 1,
        "verbId": 1,
        "mode": 0,
        "form": 0,
        "tense": 0,
        "person": 0,
        "num": 0
      };

      final verbData = [
        Verb(id: 1, la: "amo", en: "love", conjugateType: VerbConjugateType.vt1)
      ];

      final verbComponent = VerbComponent.fromJson(json, verbData);

      expect(verbComponent.id, 1);
      expect(verbComponent.verb.id, 1);
      expect(verbComponent.verb.la, "amo");
      expect(verbComponent.verb.en, "love");
      expect(verbComponent.verb.conjugateType, VerbConjugateType.vt1);
      expect(verbComponent.mode, Mode.indicative);
      expect(verbComponent.form, Form.active);
      expect(verbComponent.tense, Tense.present);
      expect(verbComponent.person, Person.first);
      expect(verbComponent.num, Numbers.single);
    });

    test('toJson returns a valid JSON map', () {
      final verb = Verb(
          id: 1, la: "amo", en: "love", conjugateType: VerbConjugateType.vt1);
      final verbComponent = VerbComponent(
        id: 1,
        verb: verb,
        mode: Mode.indicative,
        form: Form.active,
        tense: Tense.present,
        person: Person.first,
        num: Numbers.single,
      );

      final json = verbComponent.toJson();

      expect(json["id"], 1);
      expect(json["verbId"], 1);
      expect(json["mode"], 0);
      expect(json["form"], 0);
      expect(json["tense"], 0);
      expect(json["person"], 0);
      expect(json["num"], 0);
    });

    test('defaultVerbComponent has correct default values', () {
      expect(defaultVerbComponent.id, -1);
      expect(defaultVerbComponent.verb, defaultVerb);
      expect(defaultVerbComponent.mode, Mode.indicative);
      expect(defaultVerbComponent.form, Form.active);
      expect(defaultVerbComponent.tense, Tense.present);
      expect(defaultVerbComponent.person, Person.first);
      expect(defaultVerbComponent.num, Numbers.single);
    });

    group('conjugation tests', () {
      test('第一変化動詞 amo の現在形能動態', () {
        final verb = Verb(
            id: 1,
            la: "amare", // amo -> amare
            en: "love",
            conjugateType: VerbConjugateType.vt1);

        final verbComponent = VerbComponent(
          id: 1,
          verb: verb,
          mode: Mode.indicative,
          form: Form.active,
          tense: Tense.present,
          person: Person.first,
          num: Numbers.single,
        );

        expect(verbComponent.la, "amo"); // 一人称単数

        verbComponent.person = Person.second;
        expect(verbComponent.la, "amas"); // 二人称単数

        verbComponent.person = Person.third;
        verbComponent.num = Numbers.multi;
        expect(verbComponent.la, "amant"); // 三人称複数
      });

      test('第二変化動詞 video の過去形能動態', () {
        final verb = Verb(
            id: 2,
            la: "videre", // video -> videre
            en: "see",
            conjugateType: VerbConjugateType.vt2);

        final verbComponent = VerbComponent(
          id: 2,
          verb: verb,
          mode: Mode.indicative,
          form: Form.active,
          tense: Tense.past,
          person: Person.third,
          num: Numbers.single,
        );

        expect(verbComponent.la, "videbat"); // 三人称単数

        verbComponent.num = Numbers.multi;
        expect(verbComponent.la, "videbant"); // 三人称複数
      });

      test('第三変化動詞 duco の現在形受動態', () {
        final verb = Verb(
            id: 3,
            la: "ducere", // duco -> ducere
            en: "lead",
            conjugateType: VerbConjugateType.vt3);

        final verbComponent = VerbComponent(
          id: 3,
          verb: verb,
          mode: Mode.indicative,
          form: Form.passive,
          tense: Tense.present,
          person: Person.first,
          num: Numbers.multi,
        );

        expect(verbComponent.la, "ducimur"); // 一人称複数

        verbComponent.person = Person.third;
        verbComponent.num = Numbers.single;
        expect(verbComponent.la, "ducitur"); // 三人称単数
      });

      test('第三変化i型動詞 capio の接続法現在形', () {
        final verb = Verb(
            id: 4,
            la: "capere", // capio -> capere
            en: "take",
            conjugateType: VerbConjugateType.vt3i);

        final verbComponent = VerbComponent(
          id: 4,
          verb: verb,
          mode: Mode.subjunctive,
          form: Form.active,
          tense: Tense.present,
          person: Person.second,
          num: Numbers.multi,
        );

        expect(verbComponent.la, "capiatis"); // 二人称複数

        verbComponent.form = Form.passive;
        expect(verbComponent.la, "capiamini"); // 二人称複数受動態
      });

      test('第四変化動詞 audio の完了形', () {
        final verb = Verb(
            id: 5,
            la: "audire", // audio -> audire
            en: "hear",
            conjugateType: VerbConjugateType.vt4);

        final verbComponent = VerbComponent(
          id: 5,
          verb: verb,
          mode: Mode.indicative,
          form: Form.active,
          tense: Tense.presentPerfect,
          person: Person.first,
          num: Numbers.single,
        );

        expect(verbComponent.la, "audivi"); // 一人称単数

        verbComponent.person = Person.third;
        verbComponent.num = Numbers.multi;
        expect(verbComponent.la, "audiverunt"); // 三人称複数
      });
    });
  });
}
