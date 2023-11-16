import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:four_gospels/models/models.dart';
import 'package:four_gospels/quiz/models/models.dart';

class MultiPlayerService {
  final CollectionReference _roomsCollection =
      FirebaseFirestore.instance.collection('rooms').withConverter<Room>(
            fromFirestore: (snapshot, _) => Room.fromJson(snapshot.data()!),
            toFirestore: (room, _) => room.toJson(),
          );
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  Future<DocumentReference<Room>> createRoom(
    String name,
    int numQuestions,
    String code,
    Mode mode,
    String language,
  ) async {
    final room = Room(
      users: [name],
      code: code,
      lastInteraction: DateTime.now(),
      owner: name,
      numberOfQuestions: numQuestions,
      mode: mode,
      questions: List<Question>.empty(),
      language: language,
      status: 'inactive',
      usersAnswered: [],
      currentQuestionIndex: 0,
      scores: [],
    );

    final roomReference = await _roomsCollection.add(room);
    return roomReference.withConverter<Room>(
      fromFirestore: (snapshot, _) => Room.fromJson(snapshot.data()!),
      toFirestore: (room, _) => room.toJson(),
    );
  }

  Future<DocumentReference<Room>> joinRoom(
    String name,
    String code,
    String language,
  ) async {
    DocumentReference<Room> roomReference;
    try {
      roomReference = await _getRoom(code);
    } on RoomException {
      rethrow;
    }

    final roomDocSnapshot = await roomReference.get();
    final room = roomDocSnapshot.data()!;

    if (room.users.contains(name)) {
      throw RoomException(RoomExceptionErrorEnum.name);
    }

    final users = room.users..add(name);
    await roomReference.set(room.copyWith(users: users));

    return roomReference;
  }

  Future<void> removeRoom(String code) async {
    final roomReference = await _getRoom(code);
    await roomReference.delete();
  }

  Future<void> removeUserFromRoom(String name, String code) async {
    final roomReference = await _getRoom(code);
    final roomDocSnapshot = await roomReference.get();
    final room = roomDocSnapshot.data()!;

    if (room.users.contains(name)) {
      final users = room.users..remove(name);
      await roomReference.set(room.copyWith(users: users));
    }
  }

  Future<void> getQuestions(String code) async {
    final getQuestions = GetQuestions(code: code);
    await functions
        .httpsCallable('getQuestions')
        .call<void>(getQuestions.toJson());
  }

  Future<void> addUserAnswered(String code, String name) async {
    final roomReference = await _getRoom(code);
    final roomDocSnapshot = await roomReference.get();
    final room = roomDocSnapshot.data();
    final usersAnswered = room!.usersAnswered..add(name);

    await roomReference.set(room.copyWith(usersAnswered: usersAnswered));
  }

  Future<void> moveToNextQuestion(String code) async {
    final roomReference = await _getRoom(code);
    final roomDocSnapshot = await roomReference.get();
    final room = roomDocSnapshot.data();

    await roomReference.set(
      room!.copyWith(
        usersAnswered: [],
        currentQuestionIndex: room.currentQuestionIndex + 1,
      ),
    );
  }

  Future<void> addScore(
    String code,
    Score score,
  ) async {
    final roomReference = await _getRoom(code);
    final roomDocSnapshot = await roomReference.get();
    final room = roomDocSnapshot.data();
    final scores = _getScores(room!.scores, score);

    await roomReference.set(room.copyWith(scores: scores));
  }

  Future<void> modifyRoomSettings(
    String code,
    SettingsOptions option,
    dynamic value,
  ) async {
    final roomReference = await _getRoom(code);
    final roomDocSnapshot = await roomReference.get();
    final room = roomDocSnapshot.data();

    switch (option) {
      case SettingsOptions.questions:
        await roomReference
            .set(room!.copyWith(numberOfQuestions: value as int));
        break;
      case SettingsOptions.difficulty:
        await roomReference.set(room!.copyWith(mode: value as Mode));
        break;
      case SettingsOptions.language:
        await roomReference.set(room!.copyWith(language: value as String));
        break;
    }
  }

  Future<void> restartGame(String code) async {
    final roomReference = await _getRoom(code);
    final roomDocSnapshot = await roomReference.get();
    final room = roomDocSnapshot.data();

    await roomReference.set(
      room!.copyWith(
        scores: [],
        usersAnswered: [],
        currentQuestionIndex: 0,
        status: 'inactive',
      ),
    );
  }

  List<Score> _getScores(List<Score> scores, Score score) {
    final existingScoreIndex = scores.indexWhere((s) => s.name == score.name);

    if (existingScoreIndex != -1) {
      scores[existingScoreIndex] = score;
    } else {
      scores.add(score);
    }

    return scores;
  }

  Future<DocumentReference<Room>> _getRoom(String code) async {
    final roomQuerySnapshot =
        await _roomsCollection.where('code', isEqualTo: code).get();

    if (roomQuerySnapshot.size == 1) {
      return roomQuerySnapshot.docs[0].reference.withConverter<Room>(
        fromFirestore: (snapshot, _) => Room.fromJson(snapshot.data()!),
        toFirestore: (room, _) => room.toJson(),
      );
    } else {
      throw RoomException(RoomExceptionErrorEnum.room);
    }
  }
}

class GetQuestions {
  GetQuestions({required this.code});

  final String code;

  Map<String, Object?> toJson() {
    return {
      'code': code,
    };
  }
}
