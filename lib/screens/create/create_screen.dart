import 'package:find_your_leo/Tools.dart';
import 'package:find_your_leo/data/model/level_model.dart';
import 'package:find_your_leo/screens/create/widgets/MyCardWidget.dart';
import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  List<Level> levels = [];

  List<MyCardWidget> cards = [];

  @override
  void initState() {
    super.initState();
    cards.add(MyCardWidget(onDelete: onCardDeleted, index: cards.length, levelId: cards.length + 1));
  }

  void onCardDeleted(int index) {
    setState(() {
      cards.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Création d\'un nouveau salon'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            cards.add(
                MyCardWidget(onDelete: onCardDeleted, index: cards.length, levelId: cards.length + 1));
          });
        },
        heroTag: 'niv0',
        tooltip: 'Créer un niveau',
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          if (index == cards.length - 1) {
            return buildLastCard();
          } else {
            return cards[index];
          }
        },
        itemCount: cards.length,
      ),
    );
  }

  Widget buildLastCard() {
    return Column(
      children: [
        cards[cards.length - 1],
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: RaisedButton(
            onPressed: () {
              Tools.showAlertDialog(context, 'Créer la partie ?', 'Générer de code d\'accès à la partie ?', null);
            },
            child: Text(
              'Terminer',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ],
    );
  }
}
