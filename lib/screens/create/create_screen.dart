import 'package:find_your_leo/Tools.dart';
import 'package:find_your_leo/cubit/room_cubit.dart';
import 'package:find_your_leo/data/model/level_model.dart';
import 'package:find_your_leo/screens/create/widgets/MyCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  List<LevelModel> levels = [];

  @override
  void initState() {
    super.initState();
    levels.add(LevelModel(id: 1, amount: 100));
  }

  void onCardDeleted(int index) {
    setState(() {
      levels.removeAt(index);
      for (int i = 0; i < levels.length; i++) {
        levels[i].id = i + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: BlocConsumer<RoomCubit, RoomState>(
        builder: (context, state) {
          if (state is RoomInitial) {
            return buildInitial();
          } else if (state is RoomLoading) {
            return buildLoading();
          } else if (state is RoomLoading) {
            return buildInitial();
          } else {
            return buildInitial();
          }
        },
        listener: (context, state) {
          if (state is RoomError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          else if(state is RoomLoaded) {
            Navigator.of(context).pop(state.code);
          }
        },
      ),
    );
  }

  Scaffold buildInitial() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Création d\'une nouvelle partie'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            levels.add(LevelModel(id: levels.length + 1, amount: 100));
          });
        },
        heroTag: 'niv0',
        tooltip: 'Créer un niveau',
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          if (index == levels.length - 1) {
            return buildLastCard();
          } else {
            return MyCardWidget(onDelete: onCardDeleted, level: levels[index]);
          }
        },
        itemCount: levels.length,
      ),
    );
  }

  Widget buildLastCard() {
    return Column(
      children: [
        MyCardWidget(onDelete: onCardDeleted, level: levels[levels.length - 1]),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: RaisedButton(
            onPressed: () {
              Tools.showAlertDialog(
                context,
                "Créer la partie ?",
                "La partie sera ensuite accessible à partie d'un code qui te sera donné.",
                () => Navigator.of(context).pop(),
                onYes,
              );
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

  Widget buildLoading() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Création d\'une nouvelle partie'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return Tools.showAlertDialog(
        context,
        'Tu es sûr(e) ?',
        'Les données rentrées ne seront pas sauvegardées.',
        () => Navigator.of(context).pop(false),
        () => Navigator.of(context).pop(true));
  }

  void onYes() {
    Navigator.of(context).pop();

    for (var level in levels) {
      if (level.base64Image == null) {
        Tools.showAlertDialogWithOneButton(
            context,
            'Une erreur est survenue.',
            'Le niveau ${level.id} ne possède pas d\'image...',
            () => Navigator.of(context).pop());
        return;
      }
    }

    final roomCubit = BlocProvider.of<RoomCubit>(context);
    roomCubit.postRoom(levels);
  }
}
