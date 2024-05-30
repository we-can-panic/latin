import 'noun.dart';
import 'noun_utils.dart';
import 'verb.dart';
import 'verb_utils.dart';

class Sentence {
  String la;
  String en;
  List<Noun> nounComponents;
  List<Verb> verbComponents;
  int idx;

  Sentence(
      {required this.la,
      required this.en,
      required this.nounComponents,
      required this.verbComponents,
      required this.idx});

  // 連想配列からロード
  factory Sentence.fromJson(Map<String, dynamic> json) {
    // List<Person> people = jsonData.map((json) => Person.fromJson(json)).toList();
    List<dynamic> nounIds = json["nounIds"];
    List<dynamic> verbIds = json["verbIds"];
    List<Noun> nounComponents =
        nounIds.map((idx) => getNounByIdx(idx)).toList();
    List<Verb> verbComponents =
        verbIds.map((idx) => getVerbByIdx(idx)).toList();
    return Sentence(
      la: json["la"],
      en: json["en"],
      nounComponents: nounComponents,
      verbComponents: verbComponents,
      idx: json["idx"],
    );
  }
}
