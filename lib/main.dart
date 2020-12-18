import 'package:find_your_leo/cubit/images_cubit.dart';
import 'package:find_your_leo/data/image_repository.dart';
import 'package:find_your_leo/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FindYourLéo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => ImagesCubit(FakeImageRepository()),
        child: HomeScreen(),
      ),
    );
  }
}
