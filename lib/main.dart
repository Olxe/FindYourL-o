import 'package:find_your_leo/screens/start/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:find_your_leo/data/image_repository.dart';

import 'cubit/images_cubit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FindYourLéo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor: Colors.grey),
      home: BlocProvider(
        create: (context) => ImagesCubit(FakeImageRepository()),
        child: StartScreen(),
      ),
    );
  }
}
