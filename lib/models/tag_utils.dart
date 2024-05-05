Map<int, String> tagData = {};

/// input: [{id: 1, name: tag1}, {id: 2, name: tag2}]
/// output: {1: tag1, 2: tag2}
Map<int, String> tagDataFromJson(List<dynamic> json) {
  Map<int, String> result = {};
  for (var data in json) {
    int id = data["id"];
    String name = data["name"];
    result[id] = name;
  }
  return result;
}
