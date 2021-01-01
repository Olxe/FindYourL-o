part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<GameLevel> levels;
  HomeLoaded(
    this.levels,
  );

  @override
  List<Object> get props => [levels];

  @override
  String toString() => '{ code: ${levels.toString()} }';
}

class HomeError extends HomeState {
  final String message;
  HomeError({
    @required this.message,
  });

  @override
  List<Object> get props => [message];

  @override
  String toString() => '{ error: $message }';
}

