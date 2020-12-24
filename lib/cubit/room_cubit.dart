import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_your_leo/data/model/level_model.dart';
import 'package:flutter/material.dart';

import 'package:find_your_leo/data/room_repository.dart';

part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  final RoomRepository _roomRepository;

  RoomCubit(
    this._roomRepository,
  ) : super(RoomInitial());

  Future<void> postRoom(List<LevelModel> levels) async {
    try {
      emit(RoomLoading());
      String code = await _roomRepository.createRoom(levels);
      emit(RoomLoaded(code));
    } on NetworkException catch (e) {
      emit(RoomError(message: e.message));
    }
  }
}
