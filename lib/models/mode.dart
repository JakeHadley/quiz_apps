/// Modes currently supported by the question data
enum Mode {
  ///
  easy,

  ///
  moderate,

  ///
  difficult,

  ///
  random;

  ///
  String toJson() => name;

  ///
  static Mode fromJson(String json) {
    final jsonString = json.toLowerCase();

    return values.byName(jsonString);
  }
}
