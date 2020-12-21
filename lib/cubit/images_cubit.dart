import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:find_your_leo/data/image_repository.dart';
import 'package:find_your_leo/data/model/images_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'images_state.dart';

class ImagesCubit extends Cubit<ImagesState> {
  final ImageRepository _imageRepository;

  ImagesCubit(this._imageRepository) : super(ImagesInitial());

  Future<void> getImages(Size size) async {
    emit(ImagesLoading());

    final images = await _imageRepository.fetchImages(size);

    emit(ImagesLoaded(images));
  }
}
