import 'package:find_your_leo/constants.dart';
import 'package:find_your_leo/cubit/images_cubit.dart';
import 'package:find_your_leo/cubit/room_cubit.dart';
import 'package:find_your_leo/data/image_repository.dart';
import 'package:find_your_leo/data/room_repository.dart';
import 'package:find_your_leo/screens/create/create_screen.dart';
import 'package:find_your_leo/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Find The Compromise'),
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
    return Center(
      child: Card(
        elevation: 2.0,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: textController,
                  onSubmitted: (value) => submitSearchingRoom(context, value),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: "Rechercher une partie",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              RaisedButton(
                onPressed: () {
                  onCreateGameButtonPressed();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.grey)),
                child: Text('Créer ta partie !', style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void onCreateGameButtonPressed() async {
    final String code = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return BlocProvider(
            create: (context) => RoomCubit(RoomRepository()),
            child: CreateScreen(),
          );
        },
      ),
    );

    if (code != null && code.isNotEmpty) {
      textController.text = code;
    }
  }

  void submitSearchingRoom(BuildContext context, String value) {
    final myCubit = BlocProvider.of<ImagesCubit>(context);
    myCubit.getData(context, value);
  }
}
