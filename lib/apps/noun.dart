import 'package:latin/models/enumeration.dart';
import 'package:latin/models/noun.dart';
import 'package:latin/models/nounComponent.dart';
import "utils.dart";

List<Noun> nounData = [];
List<NounComponent> nounComponentData = [];

List<NounComponent> getRandomNounComponents({int num = 7}) {
  List<NounComponent> nouns = List.from(nounComponentData);
  nouns.shuffle();
  if (nouns.length < num) {
    return nouns;
  } else {
    return nouns.sublist(0, num).toList();
  }
}

List<Noun> getRandomNouns({int num = 7}) {
  List<Noun> nouns = List.from(nounData);
  nouns.shuffle();
  if (nouns.length < num) {
    return nouns;
  } else {
    return nouns.sublist(0, num).toList();
  }
}

// 他候補を返す
List<String> getRandomConjugated(Noun noun, {int size = 5}) {
  List<String> allCandidate = [];
  for (var m in Numbers.values) {
    for (var c in NounCase.values) {
      allCandidate.add(noun.conjugate(c, m));
    }
  }

  allCandidate = allCandidate.toSet().toList();
  allCandidate.shuffle();

  return allCandidate.sublist(0, size);
}

NounConjugateType getRandomNounConjugateType() {
  return NounConjugateType
      .values[random.nextInt(NounConjugateType.values.length)];
}

NounCase getRandomNounCase() {
  return NounCase.values[random.nextInt(NounCase.values.length)];
}
