import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'model/images_model.dart';

abstract class ImageRepository {
  Future<ImagesModel> fetchImages(Size size, int nbImage);
}

class FakeImageRepository implements ImageRepository {
  @override
  Future<ImagesModel> fetchImages(Size size, int nbImage) {
    return Future.delayed(Duration(milliseconds: 500), () {
      var area = size.width * (size.height - kToolbarHeight);
      var imageArea = area / nbImage;
      var imageWidth = sqrt(imageArea);
      int axisCount = (size.width / imageWidth).round() + 1;
      nbImage += axisCount - (nbImage % axisCount);

      final random = Random();
      List<Widget> images = new List();
      for (var i = 0; i < nbImage; i++) {
        var id = random.nextInt(8) + 1;

        images.add(
          GestureDetector(
            onTap: () => print('test'),
            child: ColorFiltered(
              child: Image.asset(
                'assets/images/$id.jpg',
                fit: BoxFit.cover,
              ),
              colorFilter: ColorFilter.mode(
                Colors.transparent,
                BlendMode.color,
              ),
            ),
          ),
        );
      }
      return new ImagesModel(images, axisCount);
    });
  }
}

// class MyImageRepository implements ImageRepository {
//   @override
//   Future<List<ImageModel>> fetchImages() {
//     var completer = new Completer<List<ImageModel>>();

//     List<ImageModel> images = new List();
//     for (var i = 0; i < 8; i++) {
//       images.add(new ImageModel(Image.asset('assets/images/1.jpg')));
//     }
//     completer.complete(images);

//     return completer.future;
//   }
// }
