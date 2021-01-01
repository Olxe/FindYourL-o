import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:find_your_leo/data/model/cases_model.dart';
import 'package:find_your_leo/data/model/level_model.dart';
import 'package:find_your_leo/data/room_repository.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'images_state.dart';

class ImagesCubit extends Cubit<ImagesState> {
  final RoomRepository _roomRepository;

  ImagesCubit(this._roomRepository) : super(ImagesLoading());

  Future<void> getCases(Size size, GameLevel currentLevel) async {
    if (currentLevel == null) {
      emit(ImagesError(
          "Une erreur est survenue. Impossible de charger le niveau."));
    } else {
      try {
        emit(ImagesLoading());
        final cases = await _roomRepository.fetchCases(size, currentLevel);
        emit(ImagesLoaded(cases));
      } on TimeoutException {
        emit(ImagesError('Impossible de se connecter au serveur.'));
      } on MyException catch (e) {
        emit(ImagesError(e.message));
      }
    }
  }

  Future<void> onWin(Image image) async {
    emit(WinState(image));
  }
}
