part of 'images_cubit.dart';

@immutable
abstract class ImagesState {}

class ImagesInitial extends ImagesState {}

class ImagesLoading extends ImagesState {}

class ImagesLoaded extends ImagesState {
  final CasesModel images;

  ImagesLoaded(this.images);
}

class FinishState extends ImagesState {}

class WinState extends ImagesState {
  final Image image;
  final MemoryImage memoryImage;

  WinState(this.image, this.memoryImage);
}

class DataLoadedState extends ImagesState {
  final List<Level> levelsdata;

  DataLoadedState(this.levelsdata);
}

class ImagesError extends ImagesState {
  final String message;

  ImagesError(this.message);
}
