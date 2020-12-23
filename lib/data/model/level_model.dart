import 'package:flutter/material.dart';

class Level {
  final int id;
  final String path;
  final String base64Image;
  int amount;

  Level({
    @required this.base64Image,
    @required this.id,
    @required this.amount,
    @required this.path,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: int.parse(json['id'].toString()),
      amount: int.parse(json['amount'].toString()),
      path: json['path'].toString(),
      base64Image: '',
    );
  }

  @override
  String toString() {
    return '{ $id, $amount, $path}';
  }
}
