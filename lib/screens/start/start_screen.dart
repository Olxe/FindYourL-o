import 'package:find_your_leo/constants.dart';
import 'package:find_your_leo/cubit/images_cubit.dart';
import 'package:find_your_leo/data/image_repository.dart';
import 'package:find_your_leo/screens/create/create_screen.dart';
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
      body: BlocConsumer<ImagesCubit, ImagesState>(
        builder: (context, state) {
          if (state is ImagesInitial) {
            return buildInitialScreen(context);
          } else if (state is ImagesLoading) {
            return buildLoading();
          } else if (state is DataLoadedState) {
            return buildInitialScreen(context);
          } else {
            return buildInitialScreen(context);
          }
        },
        listener: (context, state) {
          if (state is ImagesError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is DataLoadedState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return BlocProvider(
                    create: (context) => ImagesCubit(FakeImageRepository()),
                    child: HomeScreen(levels: state.levelsdata),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildInitialScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            onSubmitted: (value) => submitSearchingRoom(context, value),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "Recherchez un salon",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return BlocProvider(
                    create: (context) => ImagesCubit(FakeImageRepository()),
                    child: CreateScreen(),
                  );
                },
              ),
            );
          },
          child: Text('Créez votre salon'),
        ),
      ],
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void submitSearchingRoom(BuildContext context, String value) {
    final myCubit = BlocProvider.of<ImagesCubit>(context);
    myCubit.getData(context, value);
  }
}
