import 'package:bloc/bloc.dart';
import 'package:find_your_leo/data/image_repository.dart';
import 'package:find_your_leo/data/model/images_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'images_state.dart';

class ImagesCubit extends Cubit<ImagesState> {
  final ImageRepository _imageRepository;

  ImagesCubit(this._imageRepository) : super(ImagesInitial());

  Future<void> getImages(Size size, int nbImage) async {
    emit(ImagesLoading());
    final images = await _imageRepository.fetchImages(size, nbImage);
    emit(ImagesLoaded(images));
  }
}
