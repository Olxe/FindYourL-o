part of 'images_cubit.dart';

@immutable
abstract class ImagesState {}

class ImagesInitial extends ImagesState {}

class ImagesLoading extends ImagesState {}

class ImagesLoaded extends ImagesState {
  final CasesModel images;

  ImagesLoaded(this.images);
}

class ImagesFinished extends ImagesState {}

class WinState extends ImagesState {
  final Image image;

  WinState(this.image);
}

class ImagesError extends ImagesState {
  final String message;

  ImagesError(this.message);
}
