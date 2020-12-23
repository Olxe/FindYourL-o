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

class LevelModel {
  int id;
  String base64Image;
  int amount;

  LevelModel({
    this.base64Image,
    this.id,
    this.amount,
  });

factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: int.parse(json['id'].toString()),
      amount: int.parse(json['amount'].toString()),
      base64Image: json['base64Image'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'amount': this.amount,
    'base64Image': this.base64Image,
  };

  @override
  String toString() {
    return '{$id, $amount, ${base64Image.substring(1, 10)}}';
  }
}