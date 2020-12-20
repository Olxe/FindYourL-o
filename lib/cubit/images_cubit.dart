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

  Future<void> getImages(Size size, int nbImage) async {
    emit(ImagesLoading());
    final response = await http.get('https://placeimg.com/512/512/any');
    MemoryImage img = new MemoryImage(response.bodyBytes);
    DecorationImage de = new DecorationImage(fit: BoxFit.cover, image: img);
    Image i = new Image(image: img,);
    if (response.statusCode == 200) {
      final images = await _imageRepository.fetchImages(size, nbImage, null);
      emit(ImagesLoaded(images));
    } else {
      throw Exception('Failed to load album');
    }
  }
}
