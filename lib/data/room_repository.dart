import 'dart:convert';
import 'package:find_your_leo/data/model/level_model.dart';

import 'package:http/http.dart' as http;

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
      print(response.body);
      return response.body;
    }

    throw HomeException(
        "Une erreur est survenue lors de la création de la salle.");
  }

  Future<List<LevelModel>> fetchRoom(String code) async {
    final response = await http.get(baseURL + '/rooms/' + code);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rest = data["levels"] as List;

      List<LevelModel> levels =
          rest.map((json) => LevelModel.fromJson(json)).toList();

      if (levels.isEmpty) {
        throw HomeException(
            "Le code saisi n'existe pas !");
      }

      return levels;
    }

    throw HomeException(
        "Une erreur est survenue, impossible de rejoindre cette partie.");
  }
}

class HomeException implements Exception {
  final String message;
  HomeException(this.message);
}
