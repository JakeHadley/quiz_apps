/// Model for a [Score] object
class Score {
  ///
  Score({
    required this.name,
    required this.score,
  });

  /// Creates a [Score] object from a json object
  Score.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          score: json['score']! as int,
        );

  /// Method to convert a [Score] object to a json object
  Map<String, Object?> toJson() {
    return {
      'name': name,
      'score': score,
    };
  }

  @override
  String toString() {
    return '$name: $score';
  }

  ///
  final String name;

  ///
  final int score;
}
