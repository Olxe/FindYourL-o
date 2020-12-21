part of 'images_cubit.dart';

@immutable
abstract class ImagesState {}

class ImagesInitial extends ImagesState {}

class ImagesLoading extends ImagesState {}

class ImagesLoaded extends ImagesState {
  final CasesModel images;

  ImagesLoaded(this.images);
}

class WinState extends ImagesState {
  final Image image;
  final MemoryImage quote;

  WinState(this.image, this.quote);
}

class ImagesError extends ImagesState {
  final String message;

  ImagesError(this.message);
}
