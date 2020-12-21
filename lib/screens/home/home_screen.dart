import 'dart:async';

import 'package:find_your_leo/constants.dart';
import 'package:find_your_leo/cubit/images_cubit.dart';
import 'package:find_your_leo/data/model/cases_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _levelId = 1;
  Timer _timer;
  bool _visible = true;

  @override
  void initState() {
    super.initState();

    final imagesCubit = BlocProvider.of<ImagesCubit>(context);
    imagesCubit.getCases(Size(deviceWidth, deviceHeight));
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('FindYourFriend'),
        centerTitle: true,
      ),
      body: BlocConsumer<ImagesCubit, ImagesState>(
        builder: (context, state) {
          if (state is ImagesInitial) {
            return buildInitialScreen();
          } else if (state is ImagesLoading) {
            return buildLoading();
          } else if (state is ImagesLoaded) {
            if (_visible) {
              _timer = new Timer(const Duration(milliseconds: 500), () {
                setState(() {
                  _visible = false;
                });
              });
            }
            return buildGridView(state.images);
          } else if (state is WinState) {
            _visible = true;
            return buildSoluce(state.image);
          } else {
            return buildInitialScreen();
          }
        },
        listener: (context, state) {
          if (state is ImagesError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
      ),
    );
  }

  Widget buildInitialScreen() {
    return SizedBox.shrink();
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
                _visible ? buildLoading() : SizedBox.shrink(),
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
      height: double.infinity,
      width: double.infinity,
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
                _levelId++;
                final imagesCubit = BlocProvider.of<ImagesCubit>(context);
                imagesCubit.getCases(MediaQuery.of(context).size);
              },
              child: Text(
                'Suivant',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
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
}
