import 'package:find_your_leo/constants.dart';
import 'package:find_your_leo/cubit/images_cubit.dart';
import 'package:find_your_leo/data/image_repository.dart';
import 'package:find_your_leo/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('FindYourFriend'),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return BlocProvider(
                    create: (context) => ImagesCubit(FakeImageRepository()),
                    child: HomeScreen(),
                  );
                },
              ),
            );
          },
          child: Text('GO'),
        ),
      ),
    );
  }
}
