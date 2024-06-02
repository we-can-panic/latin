import "package:latin/database/database.dart";

// --

Map<int, String> tagData = {};

// --

class Meta {
  List<int> score;
  List<String> tags;

  Meta({required this.score, required this.tags});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      score: json["score"].split(";").map((s) => int.parse(s)).toList(),
      tags: json["tags"].split(";").map((s) => tagData[int.parse(s)]).toList(),
    );
  }
}

// --

Future<void> loadTagData() async {
  final client = await db.database;
  // 全取得する SQL を実行
  List<Map<String, dynamic>> results =
      await client.rawQuery("select id, name from $tagTable");
  // 取得した結果から WTR モデルのリストとして作成
  results.map((row) {
    int id = row["id"];
    String name = row["string"];
    tagData[id] = name;
  });
}
