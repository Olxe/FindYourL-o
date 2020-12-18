part of 'images_cubit.dart';

@immutable
abstract class ImagesState {}

class ImagesInitial extends ImagesState {}

class ImagesLoading extends ImagesState {}

class ImagesLoaded extends ImagesState {
  final ImagesModel images;

  ImagesLoaded(this.images);
}

class ImagesError extends ImagesState {
  final String message;

  ImagesError(this.message);
}
