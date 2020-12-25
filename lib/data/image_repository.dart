import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:find_your_leo/constants.dart';
import 'package:find_your_leo/screens/game/widgets/case_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/cases_model.dart';
import 'model/level_model.dart';

abstract class ImageRepository {
  Future<CasesModel> fetchCases(Size size, Level level);
  Future<List<Level>> fetchLevelsData(String levelCode);
}

class FakeImageRepository implements ImageRepository {
  @override
  Future<CasesModel> fetchCases(Size size, Level level) async {
    CaseWidget caseToFind = await fetchCaseToFind(level.path);

    var area = size.width * (size.height - kToolbarHeight);
    var imageArea = area / level.amount;
    var imageWidth = sqrt(imageArea);

    return Future.delayed(Duration.zero, () {
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
              fit: BoxFit.fill,
              width: 512,
              height: 512,
            ),
            iconSize: imageWidth,
            soluce: false,
          ),
        );
      }

      int indexToReplace = random.nextInt(images.length);
      images[indexToReplace] = caseToFind;

      return new CasesModel(images, axisCount);
    });
  }

  Future<List<Level>> fetchLevelsData(String levelCode) async {
    final res = await http
        .get(kServer + 'data/' + levelCode.toUpperCase())
        .timeout(const Duration(seconds: 5));

    if (res.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(res.body);
      // final json = JSON.decode(res.body);

      List<Level> levels = [];
      for (var level in data['levels']) {
        levels.add(Level.fromJson(level));
      }
      if(levels.isEmpty) {
        throw NetworkException("Code invalide !");
      }
      return levels;
    }

    throw NetworkException("Code invalide !");
  }

  Future<Level> fetchCurrentLevel(List<Level> levelsData, int levelId) async {
    for (Level level in levelsData) {
      if (level.id == levelId) {
        return level;
      }
    }

    throw NetworkException("Level id incorrect: " + levelId.toString());
  }

  Future<CaseWidget> fetchCaseToFind(String path) async {
    final res = await http
        .get(kServer + 'file/' + path)
        .timeout(const Duration(seconds: 5));

    if (res.statusCode == 200) {
      MemoryImage bytes = new MemoryImage(res.bodyBytes);

      return CaseWidget(
        image: Image(
          image: bytes,
          fit: BoxFit.fill,
          width: 512,
          height: 512,
        ),
        iconSize: 0,
        soluce: true,
        bytes: bytes,
        quote: 'Léo',
      );
    }

    throw "HTTP error: " + res.statusCode.toString();
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}
