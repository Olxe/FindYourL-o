import 'dart:convert';

import 'package:find_your_leo/constants.dart';
import 'package:find_your_leo/data/model/level_model.dart';

import 'package:http/http.dart' as http;

class RoomRepository {
  Future<String> createRoom(List<LevelModel> levels) async {
    var jsonRaw = jsonEncode(levels);
    var jsonFormated = "{\"levels\":" + jsonRaw + "}";

    final http.Response response = await http.post(
      kServer + 'rooms',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonFormated,
    );

    if (response.statusCode == 200) {
      print(response.body);
      return response.body;
    } 

    throw NetworkException("Une erreur est survenue lors de la création de la salle.");
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}
