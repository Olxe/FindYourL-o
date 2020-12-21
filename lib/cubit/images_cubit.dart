import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:find_your_leo/data/image_repository.dart';
import 'package:find_your_leo/data/model/cases_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'images_state.dart';

class ImagesCubit extends Cubit<ImagesState> {
  final ImageRepository _imageRepository;

  ImagesCubit(this._imageRepository) : super(ImagesInitial());

  Future<void> getCases(Size size) async {
    try {
      emit(ImagesLoading());
      final cases = await _imageRepository.fetchCases(size);
      emit(ImagesLoaded(cases));
    }
    on TimeoutException {
      emit(ImagesError('Impossible de se connecter au serveur.'));
    }
  }

  Future<void> onWin(Image image, MemoryImage quote) async {
    emit(WinState(image, quote));
  }
}
