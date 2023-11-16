import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:four_gospels/models/models.dart';
import 'package:four_gospels/quiz/models/models.dart';
import 'package:four_gospels/services/multi_player_service.dart';

part 'multi_player_event.dart';
part 'multi_player_state.dart';

class MultiPlayerBloc extends Bloc<MultiPlayerEvent, MultiPlayerState> {
  MultiPlayerBloc({required this.multiPlayerService})
      : super(MultiPlayerInitial()) {
    on<MultiPlayerCreateRoom>(_onMultiPlayerCreateRoom);
    on<MultiPlayerUpdateRoom>(_onMultiPlayerUpdateRoom);
    on<MultiPlayerReset>(_onMultiPlayerReset);
    on<MultiPlayerJoinRoom>(_onMultiPlayerJoinRoom);
    on<MultiPlayerDeleteRoom>(_onMultiPlayerDeleteRoom);
    on<MultiPlayerStart>(_onMultiPlayerStart);
    on<MultiPlayerSubmitAnswer>(_onMultiPlayerSubmitAnswer);
    on<MultiPlayerNextQuestion>(_onMultiPlayerNextQuestion);
    on<MultiPlayerComplete>(_onMultiPlayerComplete);
    on<MultiPlayerRestart>(_onMultiPlayerRestart);
    on<MultiPlayerModifyRoomSettings>(_onMultiPlayerModifyRoomSettings);
    on<MultiPlayerUpdatePoints>(_onMultiPlayerUpdatePoints);
  }

  final MultiPlayerService multiPlayerService;
  StreamSubscription<DocumentSnapshot>? _roomSubscription;

  Future<void> _onMultiPlayerCreateRoom(
    MultiPlayerCreateRoom event,
    Emitter<MultiPlayerState> emit,
  ) async {
    emit(MultiPlayerLoading());

    final roomReference = await multiPlayerService.createRoom(
      event.name,
      event.numQuestions,
      event.code,
      event.mode,
      event.language,
    );

    final roomSnapshot = await roomReference.get();
    final room = roomSnapshot.data()!;

    emit(MultiPlayerActive(room: room, name: event.name));

    _roomSubscription = roomReference.snapshots().listen(
          (snapshot) => add(MultiPlayerUpdateRoom(room: snapshot.data()!)),
        );
  }

  void _onMultiPlayerUpdateRoom(
    MultiPlayerUpdateRoom event,
    Emitter<MultiPlayerState> emit,
  ) {
    final prevState = state as MultiPlayerActive;
    emit(prevState.copyWith(room: event.room));
  }

  void _onMultiPlayerReset(
    MultiPlayerReset event,
    Emitter<MultiPlayerState> emit,
  ) {
    if (state is MultiPlayerActive) {
      final prevState = state as MultiPlayerActive;
      if (prevState.room.owner == prevState.name) {
        multiPlayerService.removeRoom(prevState.room.code);
      } else {
        multiPlayerService.removeUserFromRoom(
          prevState.name,
          prevState.room.code,
        );
      }
    }
    _roomSubscription?.cancel();
    emit(MultiPlayerInitial());
  }

  Future<void> _onMultiPlayerJoinRoom(
    MultiPlayerJoinRoom event,
    Emitter<MultiPlayerState> emit,
  ) async {
    emit(MultiPlayerLoading());

    try {
      final roomReference = await multiPlayerService.joinRoom(
        event.name,
        event.code,
        event.language,
      );

      final roomSnapshot = await roomReference.get();
      final room = roomSnapshot.data()!;

      emit(MultiPlayerActive(room: room, name: event.name));

      _roomSubscription = roomReference.snapshots().listen(
        (snapshot) {
          if (snapshot.exists) {
            add(MultiPlayerUpdateRoom(room: snapshot.data()!));
          } else {
            add(MultiPlayerDeleteRoom());
          }
        },
      );
    } on RoomException catch (e) {
      emit(MultiPlayerError(error: e.error));
    }
  }

  void _onMultiPlayerDeleteRoom(
    MultiPlayerDeleteRoom event,
    Emitter<MultiPlayerState> emit,
  ) {
    if (state is MultiPlayerActive) {
      _roomSubscription?.cancel();
      emit(MultiPlayerRoomDeleted());
    }
  }

  Future<void> _onMultiPlayerStart(
    MultiPlayerStart event,
    Emitter<MultiPlayerState> emit,
  ) async {
    await multiPlayerService.getQuestions(event.code);
  }

  Future<void> _onMultiPlayerSubmitAnswer(
    MultiPlayerSubmitAnswer event,
    Emitter<MultiPlayerState> emit,
  ) async {
    if (state is MultiPlayerActive) {
      final activeState = state as MultiPlayerActive;

      await multiPlayerService.addUserAnswered(
        activeState.room.code,
        activeState.name,
      );
    }
  }

  Future<void> _onMultiPlayerNextQuestion(
    MultiPlayerNextQuestion event,
    Emitter<MultiPlayerState> emit,
  ) async {
    if (state is MultiPlayerActive) {
      final activeState = state as MultiPlayerActive;

      await multiPlayerService.moveToNextQuestion(activeState.room.code);
    }
  }

  Future<void> _onMultiPlayerComplete(
    MultiPlayerComplete event,
    Emitter<MultiPlayerState> emit,
  ) async {
    if (state is MultiPlayerActive) {
      final activeState = state as MultiPlayerActive;

      final score = Score(name: activeState.name, score: event.score);

      await multiPlayerService.addScore(
        activeState.room.code,
        score,
      );
    }
  }

  Future<void> _onMultiPlayerRestart(
    MultiPlayerRestart event,
    Emitter<MultiPlayerState> emit,
  ) async {
    if (state is MultiPlayerActive) {
      final activeState = state as MultiPlayerActive;

      await multiPlayerService.restartGame(activeState.room.code);
    }
  }

  Future<void> _onMultiPlayerModifyRoomSettings(
    MultiPlayerModifyRoomSettings event,
    Emitter<MultiPlayerState> emit,
  ) async {
    await multiPlayerService.modifyRoomSettings(
      event.code,
      event.option,
      event.value,
    );
  }

  Future<void> _onMultiPlayerUpdatePoints(
    MultiPlayerUpdatePoints event,
    Emitter<MultiPlayerState> emit,
  ) async {
    if (state is MultiPlayerActive) {
      final activeState = state as MultiPlayerActive;
      final score = Score(name: activeState.name, score: event.score);

      await multiPlayerService.addScore(event.code, score);
    }
  }

  @override
  Future<void> close() {
    _roomSubscription?.cancel();
    return super.close();
  }
}
