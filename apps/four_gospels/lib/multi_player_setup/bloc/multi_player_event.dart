part of 'multi_player_bloc.dart';

abstract class MultiPlayerEvent extends Equatable {
  const MultiPlayerEvent();

  @override
  List<Object> get props => [];
}

class MultiPlayerSubmitAnswer extends MultiPlayerEvent {}

class MultiPlayerNextQuestion extends MultiPlayerEvent {}

class MultiPlayerReset extends MultiPlayerEvent {}

class MultiPlayerDeleteRoom extends MultiPlayerEvent {}

class MultiPlayerRestart extends MultiPlayerEvent {}

class MultiPlayerCreateRoom extends MultiPlayerEvent {
  const MultiPlayerCreateRoom({
    required this.name,
    required this.numQuestions,
    required this.code,
    required this.mode,
    required this.language,
  });

  final String name;
  final int numQuestions;
  final String code;
  final Mode mode;
  final String language;

  @override
  List<Object> get props => [
        name,
        numQuestions,
        code,
        mode,
        language,
      ];
}

class MultiPlayerUpdateRoom extends MultiPlayerEvent {
  const MultiPlayerUpdateRoom({required this.room});

  final Room room;

  @override
  List<Object> get props => [room];
}

class MultiPlayerJoinRoom extends MultiPlayerEvent {
  const MultiPlayerJoinRoom({
    required this.name,
    required this.code,
    required this.language,
  });

  final String name;
  final String code;
  final String language;

  @override
  List<Object> get props => [name, code, language];
}

class MultiPlayerStart extends MultiPlayerEvent {
  const MultiPlayerStart({required this.code});

  final String code;

  @override
  List<Object> get props => [code];
}

class MultiPlayerComplete extends MultiPlayerEvent {
  const MultiPlayerComplete({required this.score});

  final int score;

  @override
  List<Object> get props => [score];
}

class MultiPlayerModifyRoomSettings extends MultiPlayerEvent {
  const MultiPlayerModifyRoomSettings({
    required this.code,
    required this.option,
    required this.value,
  });

  final String code;
  final SettingsOptions option;
  final dynamic value;

  @override
  List<Object> get props => [code, option];
}

class MultiPlayerUpdatePoints extends MultiPlayerEvent {
  const MultiPlayerUpdatePoints({
    required this.code,
    required this.score,
  });

  final String code;
  final int score;

  @override
  List<Object> get props => [code, score];
}
