import "verb.dart";
import "word.dart";

// 活用含めたNoun
class VerbComponent {
  Verb verb;
  Mode mode;
  Form form;
  Tense tense;
  Person person;
  Numbers num;

  String get la => verb.conjugate(mode, form, tense, person, num);
  String get en => verb.en;

  VerbComponent({
    required this.verb,
    required this.mode,
    required this.form,
    required this.tense,
    required this.person,
    required this.num,
  });
}

List<VerbComponent> getRandomVerbComponents({int num = 4}) {
  return getRandomVerbs(num: 4)
      .map((v) => VerbComponent(
            verb: v,
            mode: getRandomMode(),
            form: getRandomForm(),
            tense: getRandomTense(),
            person: getRandomPerson(),
            num: getRandomNumbers(),
          ))
      .toList();
}
