class GameLevel {
  int id;
  String link;
  int amount;

  GameLevel({
    this.link,
    this.id,
    this.amount,
  });

  factory GameLevel.fromJson(Map<String, dynamic> json) {
    return GameLevel(
      id: json['id'] as int,
      amount: json['amount'] as int,
      link: json['link'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'amount': this.amount,
        'link': this.link,
      };

  @override
  String toString() {
    return '{$id, $amount, $link}';
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
      id: json['id'] as int,
      amount: json['amount'] as int,
      base64Image: json['base64Image'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'amount': this.amount,
        'base64Image': this.base64Image,
      };

  @override
  String toString() {
    return '{$id, $amount, ${base64Image.isNotEmpty}}';
  }
}
