import 'dart:convert';
import 'dart:math';
import 'package:find_your_leo/data/model/level_model.dart';
import 'package:find_your_leo/screens/game/widgets/case_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

import 'package:http/http.dart' as http;

import '../Tools.dart';
import 'model/cases_model.dart';

class RoomRepository {
  final String baseURL = 'http://192.168.1.57:4000';

  Future<String> createRoom(List<LevelModel> levels) async {
    var jsonRaw = jsonEncode(levels);
    var jsonFormated = "{\"levels\":" + jsonRaw + "}";

    final response = await http.post(
      baseURL + '/rooms',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonFormated,
    );

    if (response.statusCode == 200) {
      return response.body;
    }

    throw MyException(
        "Une erreur est survenue lors de la création de la salle.");
  }

  Future<List<GameLevel>> fetchRoom(BuildContext context, String code) async {
    final response = await http.get(baseURL + '/rooms/' + code);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rest = data["levels"] as List;

      List<GameLevel> levels =
          rest.map((json) => GameLevel.fromJson(json)).toList();

      if (levels.isEmpty) {
        throw MyException("Le code saisi n'existe pas !");
      }

      await Future.wait(
          levels.map((e) => Tools.cacheImage(context, e.link)).toList());

      return levels;
    }

    throw MyException(
        "Une erreur est survenue, impossible de rejoindre cette partie.");
  }

  Future<void> loadData() async {}

  Future<CasesModel> fetchCases(Size size, GameLevel level) async {
    CaseWidget caseToFind = CaseWidget(
      image: Image(
        image: AdvancedNetworkImage(
          level.link,
          useDiskCache: true,
        ),
        fit: BoxFit.cover,
      ),
      iconSize: 512,
      soluce: true,
    );

    var area = size.width * (size.height - kToolbarHeight);
    var imageArea = area / level.amount;
    var imageWidth = sqrt(imageArea);

    return Future.delayed(Duration(milliseconds: 1000), () {
      int axisCount = (size.width / imageWidth).round() + 1;
      level.amount += axisCount - (level.amount % axisCount);

      final random = Random();
      List<Widget> images = new List();
      
      for (var i = 0; i < level.amount; i++) {
        int id = random.nextInt(20) + 1;
        String path = 'assets/images/persons/';

        if (random.nextInt(2) == 0) {
          path = 'assets/images/random/';
        }

        images.add(
          CaseWidget(
            image: Image.asset(
              path + '$id.jpg',
              fit: BoxFit.cover,
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
}

class MyException implements Exception {
  final String message;
  MyException(this.message);
}
