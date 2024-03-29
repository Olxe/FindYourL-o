import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_your_leo/data/model/level_model.dart';
import 'package:find_your_leo/data/room_repository.dart';
import 'package:flutter/material.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final RoomRepository _roomRepository;

  HomeCubit(this._roomRepository) : super(HomeInitial());

  Future<void> getRoom(BuildContext context, String code) async {
    try {
      emit(HomeLoading());
      List<GameLevel> room = await _roomRepository.fetchRoom(context, code);
      emit(HomeLoaded(room));
    } on MyException catch (e) {
      emit(HomeError(message: e.message));
    }
  }
}
