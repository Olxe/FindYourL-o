import 'dart:async';
import 'dart:math';

import 'package:find_your_leo/screens/home/widgets/case_widget.dart';
import 'package:flutter/material.dart';

import 'model/images_model.dart';

abstract class ImageRepository {
  Future<ImagesModel> fetchImages(Size size, int nbImage, Image caseToFind);
}

class FakeImageRepository implements ImageRepository {
  @override
  Future<ImagesModel> fetchImages(Size size, int nbImage, Image caseToFind) {
    var area = size.width * (size.height - kToolbarHeight);
    var imageArea = area / nbImage;
    var imageWidth = sqrt(imageArea);

    final caseToFind = CaseWidget(
      image: Image.asset(
        'assets/dos/9.jpg',
        // 'https://placeimg.com/512/512/any',
        fit: BoxFit.cover,
        width: 1048,
        height: 1048,
      ),
      iconSize: imageWidth,
      soluce: true,
    );

    return Future.delayed(Duration(milliseconds: 500), () {
      int axisCount = (size.width / imageWidth).round() + 1;
      nbImage += axisCount - (nbImage % axisCount);

      final random = Random();
      List<Widget> images = new List();
      for (var i = 0; i < nbImage; i++) {
        int id = random.nextInt(15) + 1;
        String path = 'assets/images/persons/';

        if (random.nextInt(4) == 0) {
          path = 'assets/images/random/';
        }

        images.add(CaseWidget(
          image: Image.asset(
            path + '$id.jpg',
            fit: BoxFit.cover,
            width: 1048,
            height: 1048,
          ),
          iconSize: imageWidth,
          soluce: false,
        ));
      }

      int indexToReplace = random.nextInt(images.length);
      images[indexToReplace] = caseToFind;

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
