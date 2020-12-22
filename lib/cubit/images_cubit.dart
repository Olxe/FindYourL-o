import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:find_your_leo/data/image_repository.dart';
import 'package:find_your_leo/data/model/cases_model.dart';
import 'package:find_your_leo/data/model/level_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'images_state.dart';

class ImagesCubit extends Cubit<ImagesState> {
  final ImageRepository _imageRepository;

  ImagesCubit(this._imageRepository) : super(ImagesInitial());

  Future<void> getCases(Size size, Level level) async {
    if (level == null) {
      emit(FinishState());
    } else {
      try {
        emit(ImagesLoading());
        final cases = await _imageRepository.fetchCases(size, level);
        emit(ImagesLoaded(cases));
      } on TimeoutException {
        emit(ImagesError('Impossible de se connecter au serveur.'));
      } on NetworkException catch (e) {
        emit(ImagesError(e.message));
      }
    }
  }

  Future<void> onWin(Image image, MemoryImage memoryImage) async {
    emit(WinState(image, memoryImage));
  }

  Future<void> getData(BuildContext context, String value) async {
    try {
      emit(ImagesLoading());
      final data = await _imageRepository.fetchLevelsData(value);
      emit(DataLoadedState(data));
    } on TimeoutException {
      emit(ImagesError('Impossible de se connecter au serveur.'));
    } on NetworkException catch (e) {
      emit(ImagesError(e.message));
    }
  }
}
