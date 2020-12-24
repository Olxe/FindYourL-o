part of 'room_cubit.dart';

abstract class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomLoaded extends RoomState {
  final String code;
  RoomLoaded(
    this.code,
  );

  @override
  List<Object> get props => [code];

  @override
  String toString() => '{ code: $code }';
}

class RoomError extends RoomState {
  final String message;
  RoomError({
    @required this.message,
  });

  @override
  List<Object> get props => [message];

  @override
  String toString() => '{ error: $message }';
}
