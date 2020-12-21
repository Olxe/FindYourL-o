import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:find_your_leo/screens/home/widgets/case_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/images_model.dart';
import 'model/level_model.dart';

const server = 'http://10.0.2.2:4000/';

abstract class ImageRepository {
  Future<ImagesModel> fetchImages(Size size);
}

class FakeImageRepository implements ImageRepository {
  @override
  Future<ImagesModel> fetchImages(Size size) async {
    List<Level> levelsData = await fetchLevelsData('test');
    Level level = await fetchCurrentLevel(levelsData, 1);
    CaseWidget caseToFind = await fetchCaseToFind(level.path);

    var area = size.width * (size.height - kToolbarHeight);
    var imageArea = area / level.amount;
    var imageWidth = sqrt(imageArea);

    return Future.delayed(Duration(milliseconds: 500), () {
      int axisCount = (size.width / imageWidth).round() + 1;
      level.amount += axisCount - (level.amount % axisCount);

      final random = Random();
      List<Widget> images = new List();
      for (var i = 0; i < level.amount; i++) {
        int id = random.nextInt(15) + 1;
        String path = 'assets/images/persons/';

        if (random.nextInt(4) == 0) {
          path = 'assets/images/random/';
        }

        images.add(
          CaseWidget(
            image: Image.asset(
              path + '$id.jpg',
              fit: BoxFit.cover,
              width: 1048,
              height: 1048,
            ),
            iconSize: imageWidth,
            soluce: false,
          ),
        );
      }

      int indexToReplace = random.nextInt(images.length);
      images[indexToReplace] = caseToFind;

      return new ImagesModel(images, axisCount);
    });
  }

  Future<List<Level>> fetchLevelsData(String levelCode) async {
    final res = await http
        .get(server + 'data/' + levelCode)
        .timeout(const Duration(seconds: 5));

    if (res.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(res.body);

      List<Level> levels = [];
      for (var level in data['levels']) {
        levels.add(Level.fromJson(level));
      }
      return levels;
    }

    throw "HTTP error: " + res.statusCode.toString();
  }

  Future<Level> fetchCurrentLevel(List<Level> levelsData, int levelId) async {
    for (Level level in levelsData) {
      if (level.id == levelId) {
        return level;
      }
    }

    throw "Level id incorrect: " + levelId.toString();
  }

  Future<CaseWidget> fetchCaseToFind(String path) async {
    final res = await http
        .get(server + 'file/' + path)
        .timeout(const Duration(seconds: 5));

    if (res.statusCode == 200) {
      MemoryImage bytes = new MemoryImage(res.bodyBytes);

      return CaseWidget(
        image: Image(
          image: bytes,
          fit: BoxFit.fill,
          width: 1048,
          height: 1048,
        ),
        iconSize: 0,
        soluce: true,
      );
    }

    throw "HTTP error: " + res.statusCode.toString();
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
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
