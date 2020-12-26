import 'dart:async';

import 'package:find_your_leo/constants.dart';
import 'package:find_your_leo/cubit/images_cubit.dart';
import 'package:find_your_leo/data/model/cases_model.dart';
import 'package:find_your_leo/data/model/level_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameScreen extends StatefulWidget {
  final List<LevelModel> levels;

  const GameScreen({Key key, this.levels}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<GameScreen> {
  int _currentLevel = 1;
  Timer timer;
  bool visible = true;

  @override
  void initState() {
    super.initState();

    final myCubit = BlocProvider.of<ImagesCubit>(context);
    myCubit.getCases(Size(deviceWidth, deviceHeight), getLevel(_currentLevel));
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImagesCubit, ImagesState>(
      builder: (context, state) {
        if (state is ImagesInitial) {
          return buildScaffold(buildLoading());
        } else if (state is ImagesLoading) {
          return buildScaffold(buildLoading());
        } else if (state is ImagesLoaded) {
          if (visible) {
            timer = new Timer(const Duration(milliseconds: 2000), () {
              setState(() {
                visible = false;
              });
            });
          }
          return buildScaffold(buildGridView(state.images));
        } else if (state is WinState) {
          visible = true;
          return buildScaffold(buildSoluce(state.image));
        } else {
          return buildScaffold(buildLoading());
        }
      },
      listener: (context, state) {
        if (state is ImagesError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is ImagesFinished) {
          Navigator.pop(context);
        }
      },
    );
  }

  Scaffold buildScaffold(Widget body) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Find The Compromise'),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Center(
              child: Text(
                '$_currentLevel / ${widget.levels.length}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
      body: body,
    );
  }

  Widget buildGridView(CasesModel images) {
    return InteractiveViewer(
      minScale: 1,
      maxScale: 15,
      child: SafeArea(
        child: Center(
          child: Container(
            child: Stack(
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  crossAxisCount: images.axisCount,
                  children: images.images,
                ),
                visible ? buildLoading() : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSoluce(Image image) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Center(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Card(
              child: image,
              elevation: 10.0,
              clipBehavior: Clip.antiAlias,
            ),
            Positioned(
              bottom: 10,
              child: RaisedButton(
                onPressed: () {
                  _currentLevel++;
                  if (_currentLevel > widget.levels.length) {
                    Navigator.of(context).pop();
                  } else {
                    final imagesCubit = BlocProvider.of<ImagesCubit>(context);
                    imagesCubit.getCases(
                        MediaQuery.of(context).size, getLevel(_currentLevel));
                  }
                },
                child: Text(
                  'Suivant',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  LevelModel getLevel(int levelIndex) {
    for (var level in widget.levels) {
      if (level.id == levelIndex) {
        return level;
      }
    }
    return null;
  }
}
