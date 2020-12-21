import 'package:flutter/material.dart';

class Level {
  final int id;
  final String path;
  int amount;

  Level({
    @required this.id,
    @required this.amount,
    @required this.path,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: int.parse(json['id'].toString()),
      amount: int.parse(json['amount'].toString()),
      path: json['path'].toString(),
    );
  }

  @override
  String toString() {
    return '{ $id, $amount, $path}';
  }
}
