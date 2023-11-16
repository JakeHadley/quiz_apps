part of 'multi_player_bloc.dart';

abstract class MultiPlayerState extends Equatable {
  const MultiPlayerState();

  @override
  List<Object> get props => [];
}

class MultiPlayerInitial extends MultiPlayerState {}

class MultiPlayerRoomDeleted extends MultiPlayerState {}

class MultiPlayerLoading extends MultiPlayerState {}

class MultiPlayerActive extends MultiPlayerState {
  const MultiPlayerActive({
    required this.room,
    required this.name,
  });

  MultiPlayerActive copyWith({
    Room? room,
    String? name,
  }) {
    return MultiPlayerActive(
      room: room ?? this.room,
      name: name ?? this.name,
    );
  }

  final Room room;
  final String name;

  @override
  List<Object> get props => [room, name];
}

class MultiPlayerError extends MultiPlayerState {
  const MultiPlayerError({required this.error});

  final RoomExceptionErrorEnum error;

  @override
  List<Object> get props => [error];
}
