import 'package:latin/models/enumeration.dart';
import 'package:latin/models/verb.dart';
import 'package:latin/models/nounComponent.dart';
import 'package:latin/models/verbComponent.dart';
import "utils.dart";

List<Verb> verbData = [];
List<VerbComponent> verbComponentData = [];

List<VerbComponent> getRandomVerbComponents({int num = 7}) {
  List<VerbComponent> verbs = List.from(verbComponentData);
  verbs.shuffle();
  if (verbs.length < num) {
    return verbs;
  } else {
    return verbs.sublist(0, num).toList();
  }
}

List<Verb> getRandomVerbs({int num = 7}) {
  List<Verb> verbs = List.from(verbData);
  verbs.shuffle();
  if (verbs.length < num) {
    return verbs;
  } else {
    return verbs.sublist(0, num).toList();
  }
}
