import "noun.dart";
import "word.dart";

// 活用含めたNoun
class NounComponent {
  Noun noun;
  NounConjugateType conjugateType;
  Numbers num;

  String get la => noun.conjugate(conjugateType, num);
  String get en => noun.en;

  NounComponent({
    required this.noun,
    required this.conjugateType,
    required this.num,
  });
}

List<NounComponent> getRandomNounComponents({int num = 4}) {
  return getRandomNouns(num: num)
      .map((n) => NounComponent(
            noun: n,
            conjugateType: getRandomNounConjugateType(),
            num: getRandomNumbers(),
          ))
      .toList();
}
